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

trait Mock {
  val user: String
}

case class Greeting(message: String, user: String) extends Mock

case class Now(now: String, user: String) extends Mock

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

  type Key = String
  type CurrentState = (Int, String)

  def updateFunction(newValues: Seq[Mock], currentState: Option[CurrentState]): Option[CurrentState] = {
    currentState match {
      case None => {
        val state: Option[(Int, String)] = newValues.foldLeft(Option((0, "")))((acc, mock) => {
          //log.info(s"NONE: $mock")
          mock match {
            case Greeting(message, user) => Some((acc.get._1 + 1, s"$message ${acc.get._2}"))
            case Now(now, user) => Some((acc.get._1 + 1, s"${acc.get._2} $now"))
          }
        })
        //log.info(s"NONE: $state")
        state
      }
      case Some((1, msg)) => {
        val state: Option[(Int, String)] = newValues
          .foldLeft(Option(1, msg))((acc, mock) => {
            //log.info(s"1: $mock")
            mock match {
              case Greeting(message, user) => Some((acc.get._1 + 1, s"$message ${acc.get._2}"))
              case Now(now, user) => Some((acc.get._1 + 1, s"${acc.get._2} $now"))
            }
          })
        //log.info(s"1: $state")
        state
      }
      case Some((2, msg)) => {
        //log.info(s"2: $msg");
        val state: Option[(Int, String)] = newValues.foldLeft(None)((acc, mock) => None)
        //log.info(s"2: $state")
        state
      }
      case Some(_) => {
        //log.info(s"DONE")
        None
      }
    }
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
    }) cache()

    val greetingList: DStream[(String, Mock)] = input
      .filter(t => t._2 == "g" || t._2 == "b")
      .map(t => callGreeting(t._1))
      .map(_.unsafeRun())
      .map(g => (g.user, g.asInstanceOf[Mock]))
      .cache()

    val dateList: DStream[(String, Mock)] = input
      .filter(t => t._2 == "d" || t._2 == "b")
      .map(t => callDate(t._1))
      .map(_.unsafeRun())
      .map(d => (d.user, d.asInstanceOf[Mock]))
      .cache()

    //val grouped: DStream[(String, Iterable[String])] = greetingList
    //val grouped: DStream[(String, CurrentState)] = greetingList
    greetingList
      .union(dateList)
      .updateStateByKey[CurrentState](updateFunction _)
      .filter(tup => tup._2._1 == 2)
      .foreachRDD((rdd: RDD[(String, CurrentState)]) => rdd.foreach { tup =>
        log.info(s"${tup._1} -> ${tup._2._1} ${tup._2._2}")
      })
    //.groupByKey()
    //.filter( gbk => gbk._2.size > 1)
    //.groupByKeyAndWindow(Seconds(60), Seconds(180)).cache()

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
  def setLogLevels(): Unit = {
    val log4jInitialized = Logger.getRootLogger.getAllAppenders.hasMoreElements
    if (!log4jInitialized) {
      // This is to make sure that the console is clean from other INFO messages printed by Spark
      Logger.getRootLogger.setLevel(Level.INFO)
    }
  }
}
