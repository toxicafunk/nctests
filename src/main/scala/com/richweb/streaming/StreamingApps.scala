package com.richweb.streaming

import java.time.{LocalDateTime, ZoneOffset}

import fs2.{Strategy, Task}
import org.apache.log4j.{Level, LogManager, Logger}
import org.apache.spark.sql.SparkSession
import org.apache.spark.storage.StorageLevel
import org.apache.spark.streaming.dstream.{DStream, ReceiverInputDStream}
import org.apache.spark.streaming.{Duration, Seconds, StreamingContext, Time}
import org.http4s.{EntityDecoder, Uri}
import org.http4s.client.blaze._
import io.circe.generic.auto._
import org.apache.spark.rdd.RDD
import org.http4s.circe._
import scala.concurrent.duration._

trait Mock
case class Greeting ( message: String, user: String) extends Mock
case class Now ( now: String, user: String) extends Mock

object StreamingApps {

  @transient lazy val log = org.apache.log4j.LogManager.getLogger("myLogger")

  implicit val strategy = Strategy.fromExecutionContext(scala.concurrent.ExecutionContext.Implicits.global)

  val longTimeoutConfig =
    BlazeClientConfig
      .defaultConfig
      .copy(responseHeaderTimeout = 2.5.minutes, idleTimeout = 5.minutes)
  val client = PooledHttp1Client(config = longTimeoutConfig)

  def callGreeting[T](name: String): Task[Greeting] = {
    val target = Uri.uri("http://localhost:9595/hello/") / name
    log.info(s"Calling $target")
    client.expect(target)(jsonOf[Greeting])
  }

  def callDate(name: String): Task[Now] = {
    val target = Uri.uri("http://localhost:9090/now/") / name
    log.info(s"Calling $target")
    client.expect(target)(jsonOf[Now])
  }

  //def callGreeting = (call("http://localhost:9595/hello/") _).andThen(t => t.map(s => ))
  //def callDate = call("http://localhost:9090/now/") _

  def main(args: Array[String]): Unit = {
    // Log level settings
    LogSettings.setLogLevels()

    // Create the Spark Session and the spark context
    val spark = SparkSession
      .builder
        //.config("spark.rpc.numRetries", 2)
        //.config("spark.rpc.retry.wait", 60)
        .config("spark.task.maxFailures", 2)
        .config("spark.scheduler.maxRegisteredResourcesWaitingTime", 70)
      .appName(getClass.getSimpleName)
      .getOrCreate()

    // Get the Spark context from the Spark session for creating the streaming context
    val sc = spark.sparkContext

    spark.conf.getAll.foreach { elem =>
      log.info(s"${elem._1} -> ${elem._2}")
    }

    // Create the streaming context
    val ssc = new StreamingContext(sc, Seconds(10))

    // Set the check point directory for saving the data to recover when there is a crash
    ssc.checkpoint("/tmp")
    log.info("Stream processing logic start")

    // Create a DStream that connects to localhost on port 9999
    // The StorageLevel.MEMORY_AND_DISK_SER indicates that the data will be stored in memory and if it overflows, in disk as well
    val stream: ReceiverInputDStream[String] = ssc.socketTextStream("localhost", 9999, StorageLevel.MEMORY_AND_DISK_SER)

    val input = stream.map(s => {
      val tup = s.split(" ")
      (tup(0), tup(1))
    })cache()

    val greetingList: DStream[Greeting] = input
      .filter(t => t._2 == "g" || t._2 == "b")
      .map(t => callGreeting(t._1))
      .map(_.unsafeRun())

    val dateList: DStream[Now] = input
      .filter(t => t._2 == "d" || t._2 == "b")
      .map(t => callDate(t._1))
      .map(_.unsafeRun())

    /*val currentTime = new Time(LocalDateTime.now().toEpochSecond(ZoneOffset.UTC))
    greetingList.slice(currentTime, currentTime.-(Seconds(10)))*/

    val grouped: DStream[(String, Iterable[String])] = greetingList
      .map(g => (g.user, g.message))
      .union(dateList.map(d => (d.user, d.now)))
      .groupByKey()
      //.groupByKeyAndWindow(Seconds(60), Seconds(180)).cache()

    grouped.foreachRDD( (rdd: RDD[(String, Iterable[String])]) => rdd.foreach { tup =>
      log.info(tup._2.reduceLeft( (acc, s) => acc + " " + s))
    })

    log.info("Stream processing logic end")
    // Start the streaming
    ssc.start()
    // Wait till the application is terminated
    ssc.awaitTermination()
  }
}


object LogSettings {
  /**
    * Necessary log4j logging level settings are done
    */
  def setLogLevels():Unit = {
    val log4jInitialized = Logger.getRootLogger.getAllAppenders.hasMoreElements
    if (!log4jInitialized) {
      // This is to make sure that the console is clean from other INFO messages printed by Spark
      Logger.getRootLogger.setLevel(Level.INFO)
    }
  }
}
