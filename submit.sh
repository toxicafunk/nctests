#!/bin/bash
#-----------
# submit.sh
#-----------
# IMPORTANT - Assumption is that the $SPARK_HOME and $KAFKA_HOME environment variables are already set in the system that is running the application

# [FILLUP] Which is your Spark master. If monitoring is needed, use the desired Spark master or use local
# When using the local mode. It is important to give more than one cores in square brackets
SPARK_MASTER=spark://tpw530:7077
#SPARK_MASTER=local[4]

# [OPTIONAL] Your Scala version
SCALA_VERSION="2.11"

# [OPTIONAL] Name of the application jar file. You should be OK to leave it like that
APP_JAR="netcat-tests_$SCALA_VERSION-1.0.jar"

# [OPTIONAL] Absolute path to the application jar file
PATH_TO_APP_JAR="target/scala-$SCALA_VERSION/$APP_JAR"

# [OPTIONAL] Spark submit command
SPARK_SUBMIT="$SPARK_HOME/bin/spark-submit"

# [OPTIONAL] Pass the application name to run as the parameter to this script
APP_TO_RUN=$1

sbt package
if [ $2 -eq 1 ]
then
  $SPARK_SUBMIT --class $APP_TO_RUN --master $SPARK_MASTER --jars $KAFKA_HOME/libs/kafka-clients-0.8.2.2.jar,$KAFKA_HOME/libs/kafka_2.11-0.8.2.2.jar,$KAFKA_HOME/libs/metrics-core-2.2.0.jar,$KAFKA_HOME/libs/zkclient-0.3.jar,./lib/spark-streaming-kafka-0-8_2.11-2.0.0-preview.jar $PATH_TO_APP_JAR
else
  $SPARK_SUBMIT --class $APP_TO_RUN --master $SPARK_MASTER \
  --jars lib_managed/jars/aopalliance/aopalliance/aopalliance-1.0.jar,lib_managed/jars/org.antlr/antlr4-runtime/antlr4-runtime-4.5.3.jar,lib_managed/jars/com.clearspring.analytics/stream/stream-2.7.0.jar,lib_managed/jars/org.mortbay.jetty/jetty-util/jetty-util-6.1.26.jar,lib_managed/jars/co.fs2/fs2-core_2.11/fs2-core_2.11-0.9.7.jar,lib_managed/jars/co.fs2/fs2-cats_2.11/fs2-cats_2.11-0.3.0.jar,lib_managed/jars/co.fs2/fs2-io_2.11/fs2-io_2.11-0.9.7.jar,lib_managed/jars/org.scalanlp/breeze_2.11/breeze_2.11-0.12.jar,lib_managed/jars/org.scalanlp/breeze-macros_2.11/breeze-macros_2.11-0.12.jar,lib_managed/jars/org.apache.hadoop/hadoop-mapreduce-client-shuffle/hadoop-mapreduce-client-shuffle-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-yarn-client/hadoop-yarn-client-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-hdfs/hadoop-hdfs-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-mapreduce-client-common/hadoop-mapreduce-client-common-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-auth/hadoop-auth-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-client/hadoop-client-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-mapreduce-client-app/hadoop-mapreduce-client-app-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-mapreduce-client-jobclient/hadoop-mapreduce-client-jobclient-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-annotations/hadoop-annotations-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-mapreduce-client-core/hadoop-mapreduce-client-core-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-yarn-server-common/hadoop-yarn-server-common-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-yarn-api/hadoop-yarn-api-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-common/hadoop-common-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-yarn-common/hadoop-yarn-common-2.2.0.jar,lib_managed/jars/org.apache.hadoop/hadoop-yarn-server-nodemanager/hadoop-yarn-server-nodemanager-2.2.0.jar,lib_managed/jars/commons-lang/commons-lang/commons-lang-2.5.jar,lib_managed/jars/net.jpountz.lz4/lz4/lz4-1.3.0.jar,lib_managed/jars/commons-beanutils/commons-beanutils/commons-beanutils-1.7.0.jar,lib_managed/jars/commons-beanutils/commons-beanutils-core/commons-beanutils-core-1.8.0.jar,lib_managed/jars/org.objenesis/objenesis/objenesis-2.1.jar,lib_managed/jars/org.apache.zookeeper/zookeeper/zookeeper-3.4.5.jar,lib_managed/jars/net.java.dev.jets3t/jets3t/jets3t-0.7.1.jar,lib_managed/jars/com.github.mpilquist/simulacrum_2.11/simulacrum_2.11-0.10.0.jar,lib_managed/jars/javax.inject/javax.inject/javax.inject-1.jar,lib_managed/jars/com.thoughtworks.paranamer/paranamer/paranamer-2.6.jar,lib_managed/jars/javax.validation/validation-api/validation-api-1.1.0.Final.jar,lib_managed/jars/net.sf.py4j/py4j/py4j-0.10.4.jar,lib_managed/jars/commons-io/commons-io/commons-io-2.1.jar,lib_managed/jars/oro/oro/oro-2.0.8.jar,lib_managed/jars/commons-codec/commons-codec/commons-codec-1.10.jar,lib_managed/jars/javax.ws.rs/javax.ws.rs-api/javax.ws.rs-api-2.0.1.jar,lib_managed/jars/org.codehaus.jackson/jackson-mapper-asl/jackson-mapper-asl-1.9.13.jar,lib_managed/jars/org.codehaus.jackson/jackson-core-asl/jackson-core-asl-1.9.13.jar,lib_managed/jars/org.sonatype.sisu.inject/cglib/cglib-2.2.1-v20090111.jar,lib_managed/jars/net.razorvine/pyrolite/pyrolite-4.13.jar,lib_managed/jars/org.glassfish.jersey.containers/jersey-container-servlet/jersey-container-servlet-2.22.2.jar,lib_managed/jars/org.glassfish.jersey.containers/jersey-container-servlet-core/jersey-container-servlet-core-2.22.2.jar,lib_managed/jars/org.glassfish.jersey.media/jersey-media-jaxb/jersey-media-jaxb-2.22.2.jar,lib_managed/jars/commons-collections/commons-collections/commons-collections-3.2.1.jar,lib_managed/jars/org.tukaani/xz/xz-1.0.jar,lib_managed/jars/org.scala-lang/scalap/scalap-2.11.8.jar,lib_managed/jars/org.scala-lang/scala-compiler/scala-compiler-2.11.8.jar,lib_managed/jars/org.scala-lang/scala-library/scala-library-2.11.8.jar,lib_managed/jars/org.scala-lang/scala-reflect/scala-reflect-2.11.8.jar,lib_managed/jars/org.typelevel/macro-compat_2.11/macro-compat_2.11-1.1.1.jar,lib_managed/jars/org.typelevel/cats-macros_2.11/cats-macros_2.11-0.9.0.jar,lib_managed/jars/org.typelevel/cats-kernel_2.11/cats-kernel_2.11-0.9.0.jar,lib_managed/jars/org.typelevel/cats-core_2.11/cats-core_2.11-0.9.0.jar,lib_managed/jars/org.typelevel/machinist_2.11/machinist_2.11-0.6.1.jar,lib_managed/jars/com.github.rwl/jtransforms/jtransforms-2.4.0.jar,lib_managed/jars/org.codehaus.janino/janino/janino-3.0.7.jar,lib_managed/jars/org.codehaus.janino/commons-compiler/commons-compiler-3.0.7.jar,lib_managed/jars/io.netty/netty-all/netty-all-4.0.43.Final.jar,lib_managed/jars/org.spire-math/jawn-parser_2.11/jawn-parser_2.11-0.10.4.jar,lib_managed/jars/org.spire-math/spire-macros_2.11/spire-macros_2.11-0.7.4.jar,lib_managed/jars/org.spire-math/spire_2.11/spire_2.11-0.7.4.jar,lib_managed/jars/org.jpmml/pmml-model/pmml-model-1.2.15.jar,lib_managed/jars/org.jpmml/pmml-schema/pmml-schema-1.2.15.jar,lib_managed/jars/com.google.code.findbugs/jsr305/jsr305-1.3.9.jar,lib_managed/jars/io.circe/circe-literal_2.11/circe-literal_2.11-0.8.0.jar,lib_managed/jars/io.circe/circe-core_2.11/circe-core_2.11-0.8.0.jar,lib_managed/jars/io.circe/circe-generic_2.11/circe-generic_2.11-0.8.0.jar,lib_managed/jars/io.circe/circe-jawn_2.11/circe-jawn_2.11-0.8.0.jar,lib_managed/jars/io.circe/circe-numbers_2.11/circe-numbers_2.11-0.8.0.jar,lib_managed/jars/commons-httpclient/commons-httpclient/commons-httpclient-3.1.jar,lib_managed/jars/org.glassfish.hk2/hk2-locator/hk2-locator-2.4.0-b34.jar,lib_managed/jars/org.glassfish.hk2/hk2-api/hk2-api-2.4.0-b34.jar,lib_managed/jars/org.glassfish.hk2/hk2-utils/hk2-utils-2.4.0-b34.jar,lib_managed/jars/org.glassfish.hk2/osgi-resource-locator/osgi-resource-locator-1.0.1.jar,lib_managed/jars/org.eclipse.jetty.alpn/alpn-api/alpn-api-1.1.2.v20150522.jar,lib_managed/jars/xmlenc/xmlenc/xmlenc-0.52.jar,lib_managed/jars/com.github.fommil.netlib/core/core-1.1.2.jar,lib_managed/jars/org.slf4j/jul-to-slf4j/jul-to-slf4j-1.7.16.jar,lib_managed/jars/org.slf4j/slf4j-log4j12/slf4j-log4j12-1.7.16.jar,lib_managed/jars/org.slf4j/jcl-over-slf4j/jcl-over-slf4j-1.7.16.jar,lib_managed/jars/org.slf4j/slf4j-api/slf4j-api-1.7.25.jar,lib_managed/jars/javax.annotation/javax.annotation-api/javax.annotation-api-1.2.jar,lib_managed/jars/org.apache.commons/commons-compress/commons-compress-1.4.1.jar,lib_managed/jars/org.apache.commons/commons-crypto/commons-crypto-1.0.0.jar,lib_managed/jars/org.apache.commons/commons-math/commons-math-2.1.jar,lib_managed/jars/org.apache.commons/commons-lang3/commons-lang3-3.5.jar,lib_managed/jars/org.apache.commons/commons-math3/commons-math3-3.4.1.jar,lib_managed/jars/org.glassfish.jersey.core/jersey-common/jersey-common-2.22.2.jar,lib_managed/jars/org.glassfish.jersey.core/jersey-client/jersey-client-2.22.2.jar,lib_managed/jars/org.glassfish.jersey.core/jersey-server/jersey-server-2.22.2.jar,lib_managed/jars/org.apache.parquet/parquet-common/parquet-common-1.8.1.jar,lib_managed/jars/org.apache.parquet/parquet-jackson/parquet-jackson-1.8.1.jar,lib_managed/jars/org.apache.parquet/parquet-column/parquet-column-1.8.1.jar,lib_managed/jars/org.apache.parquet/parquet-hadoop/parquet-hadoop-1.8.1.jar,lib_managed/jars/org.apache.parquet/parquet-format/parquet-format-2.3.0-incubating.jar,lib_managed/jars/org.apache.parquet/parquet-encoding/parquet-encoding-1.8.1.jar,lib_managed/jars/commons-net/commons-net/commons-net-2.2.jar,lib_managed/jars/commons-configuration/commons-configuration/commons-configuration-1.6.jar,lib_managed/jars/jline/jline/jline-2.12.1.jar,lib_managed/jars/org.scalamacros/paradise_2.11.8/paradise_2.11.8-2.1.0.jar,lib_managed/jars/javax.servlet/javax.servlet-api/javax.servlet-api-3.1.0.jar,lib_managed/jars/org.glassfish.hk2.external/aopalliance-repackaged/aopalliance-repackaged-2.4.0-b34.jar,lib_managed/jars/org.glassfish.hk2.external/javax.inject/javax.inject-2.4.0-b34.jar,lib_managed/jars/net.sf.opencsv/opencsv/opencsv-2.3.jar,lib_managed/jars/commons-cli/commons-cli/commons-cli-1.2.jar,lib_managed/jars/commons-digester/commons-digester/commons-digester-1.8.jar,lib_managed/jars/org.json4s/json4s-jackson_2.11/json4s-jackson_2.11-3.2.11.jar,lib_managed/jars/org.json4s/json4s-ast_2.11/json4s-ast_2.11-3.2.11.jar,lib_managed/jars/org.json4s/json4s-core_2.11/json4s-core_2.11-3.2.11.jar,lib_managed/jars/net.sourceforge.f2j/arpack_combined_all/arpack_combined_all-0.1.jar,lib_managed/jars/com.univocity/univocity-parsers/univocity-parsers-2.2.1.jar,lib_managed/jars/com.google.inject/guice/guice-3.0.jar,lib_managed/jars/com.twitter/hpack/hpack-v1.0.1.jar,lib_managed/jars/com.twitter/chill-java/chill-java-0.8.0.jar,lib_managed/jars/com.twitter/chill_2.11/chill_2.11-0.8.0.jar,lib_managed/jars/org.apache.ivy/ivy/ivy-2.4.0.jar,lib_managed/jars/org.apache.kafka/kafka-clients/kafka-clients-0.8.2.1.jar,lib_managed/jars/org.apache.kafka/kafka_2.11/kafka_2.11-0.8.2.1.jar,lib_managed/jars/com.yammer.metrics/metrics-core/metrics-core-2.2.0.jar,lib_managed/jars/org.log4s/log4s_2.11/log4s_2.11-1.3.6.jar,lib_managed/jars/org.apache.avro/avro/avro-1.7.7.jar,lib_managed/jars/org.apache.avro/avro-ipc/avro-ipc-1.7.7-tests.jar,lib_managed/jars/org.apache.avro/avro-ipc/avro-ipc-1.7.7.jar,lib_managed/jars/org.apache.avro/avro-mapred/avro-mapred-1.7.7-hadoop2.jar,lib_managed/jars/com.101tec/zkclient/zkclient-0.3.jar,lib_managed/jars/org.http4s/http4s-blaze-client_2.11/http4s-blaze-client_2.11-0.17.5.jar,lib_managed/jars/org.http4s/http4s-client_2.11/http4s-client_2.11-0.17.5.jar,lib_managed/jars/org.http4s/jawn-fs2_2.11/jawn-fs2_2.11-0.10.1.jar,lib_managed/jars/org.http4s/http4s-circe_2.11/http4s-circe_2.11-0.17.5.jar,lib_managed/jars/org.http4s/http4s-blaze-core_2.11/http4s-blaze-core_2.11-0.17.5.jar,lib_managed/jars/org.http4s/http4s-jawn_2.11/http4s-jawn_2.11-0.17.5.jar,lib_managed/jars/org.http4s/blaze-core_2.11/blaze-core_2.11-0.12.9.jar,lib_managed/jars/org.http4s/parboiled_2.11/parboiled_2.11-1.0.0.jar,lib_managed/jars/org.http4s/http4s-websocket_2.11/http4s-websocket_2.11-0.2.0.jar,lib_managed/jars/org.http4s/http4s-core_2.11/http4s-core_2.11-0.17.5.jar,lib_managed/jars/org.http4s/blaze-http_2.11/blaze-http_2.11-0.12.9.jar,lib_managed/bundles/org.apache.xbean/xbean-asm5-shaded/xbean-asm5-shaded-4.4.jar,lib_managed/bundles/org.xerial.snappy/snappy-java/snappy-java-1.1.2.6.jar,lib_managed/bundles/io.dropwizard.metrics/metrics-graphite/metrics-graphite-3.1.2.jar,lib_managed/bundles/io.dropwizard.metrics/metrics-jvm/metrics-jvm-3.1.2.jar,lib_managed/bundles/io.dropwizard.metrics/metrics-core/metrics-core-3.1.2.jar,lib_managed/bundles/io.dropwizard.metrics/metrics-json/metrics-json-3.1.2.jar,lib_managed/bundles/com.esotericsoftware/minlog/minlog-1.3.0.jar,lib_managed/bundles/com.esotericsoftware/kryo-shaded/kryo-shaded-3.0.3.jar,lib_managed/bundles/org.roaringbitmap/RoaringBitmap/RoaringBitmap-0.5.11.jar,lib_managed/bundles/org.glassfish.jersey.bundles.repackaged/jersey-guava/jersey-guava-2.22.2.jar,lib_managed/bundles/com.chuusai/shapeless_2.11/shapeless_2.11-2.3.2.jar,lib_managed/bundles/com.ning/compress-lzf/compress-lzf-1.0.3.jar,lib_managed/bundles/org.fusesource.leveldbjni/leveldbjni-all/leveldbjni-all-1.8.jar,lib_managed/bundles/com.fasterxml.jackson.core/jackson-annotations/jackson-annotations-2.6.5.jar,lib_managed/bundles/com.fasterxml.jackson.core/jackson-databind/jackson-databind-2.6.5.jar,lib_managed/bundles/com.fasterxml.jackson.core/jackson-core/jackson-core-2.6.5.jar,lib_managed/bundles/io.netty/netty/netty-3.8.0.Final.jar,lib_managed/bundles/org.javassist/javassist/javassist-3.18.1-GA.jar,lib_managed/bundles/org.apache.curator/curator-client/curator-client-2.4.0.jar,lib_managed/bundles/org.apache.curator/curator-recipes/curator-recipes-2.4.0.jar,lib_managed/bundles/org.apache.curator/curator-framework/curator-framework-2.4.0.jar,lib_managed/bundles/org.scodec/scodec-bits_2.11/scodec-bits_2.11-1.1.5.jar,lib_managed/bundles/log4j/log4j/log4j-1.2.17.jar,lib_managed/bundles/org.scala-lang.modules/scala-xml_2.11/scala-xml_2.11-1.0.4.jar,lib_managed/bundles/org.scala-lang.modules/scala-xml_2.11/scala-xml_2.11-1.0.5.jar,lib_managed/bundles/org.scala-lang.modules/scala-parser-combinators_2.11/scala-parser-combinators_2.11-1.0.4.jar,lib_managed/bundles/com.google.guava/guava/guava-14.0.1.jar,lib_managed/bundles/com.fasterxml.jackson.module/jackson-module-paranamer/jackson-module-paranamer-2.6.5.jar,lib_managed/bundles/com.fasterxml.jackson.module/jackson-module-scala_2.11/jackson-module-scala_2.11-2.6.5.jar,lib_managed/bundles/com.google.protobuf/protobuf-java/protobuf-java-2.5.0.jar,lib_managed/srcs/aopalliance/aopalliance/aopalliance-1.0-sources.jar,lib_managed/srcs/org.antlr/antlr4-runtime/antlr4-runtime-4.5.3-sources.jar,lib_managed/srcs/com.clearspring.analytics/stream/stream-2.7.0-sources.jar,lib_managed/srcs/org.mortbay.jetty/jetty-util/jetty-util-6.1.26-sources.jar,lib_managed/srcs/co.fs2/fs2-core_2.11/fs2-core_2.11-0.9.7-sources.jar,lib_managed/srcs/co.fs2/fs2-cats_2.11/fs2-cats_2.11-0.3.0-sources.jar,lib_managed/srcs/co.fs2/fs2-io_2.11/fs2-io_2.11-0.9.7-sources.jar,lib_managed/srcs/org.scalanlp/breeze_2.11/breeze_2.11-0.12-sources.jar,lib_managed/srcs/org.scalanlp/breeze-macros_2.11/breeze-macros_2.11-0.12-sources.jar,lib_managed/srcs/org.apache.xbean/xbean-asm5-shaded/xbean-asm5-shaded-4.4-sources.jar,lib_managed/srcs/org.xerial.snappy/snappy-java/snappy-java-1.1.2.6-sources.jar,lib_managed/srcs/io.dropwizard.metrics/metrics-graphite/metrics-graphite-3.1.2-sources.jar,lib_managed/srcs/io.dropwizard.metrics/metrics-jvm/metrics-jvm-3.1.2-sources.jar,lib_managed/srcs/io.dropwizard.metrics/metrics-core/metrics-core-3.1.2-sources.jar,lib_managed/srcs/io.dropwizard.metrics/metrics-json/metrics-json-3.1.2-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-mapreduce-client-shuffle/hadoop-mapreduce-client-shuffle-2.2.0-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-yarn-client/hadoop-yarn-client-2.2.0-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-hdfs/hadoop-hdfs-2.2.0-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-mapreduce-client-common/hadoop-mapreduce-client-common-2.2.0-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-auth/hadoop-auth-2.2.0-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-mapreduce-client-app/hadoop-mapreduce-client-app-2.2.0-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-mapreduce-client-jobclient/hadoop-mapreduce-client-jobclient-2.2.0-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-annotations/hadoop-annotations-2.2.0-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-mapreduce-client-core/hadoop-mapreduce-client-core-2.2.0-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-yarn-server-common/hadoop-yarn-server-common-2.2.0-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-yarn-api/hadoop-yarn-api-2.2.0-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-common/hadoop-common-2.2.0-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-yarn-common/hadoop-yarn-common-2.2.0-sources.jar,lib_managed/srcs/org.apache.hadoop/hadoop-yarn-server-nodemanager/hadoop-yarn-server-nodemanager-2.2.0-sources.jar,lib_managed/srcs/commons-lang/commons-lang/commons-lang-2.5-sources.jar,lib_managed/srcs/net.jpountz.lz4/lz4/lz4-1.3.0-sources.jar,lib_managed/srcs/commons-beanutils/commons-beanutils/commons-beanutils-1.7.0-sources.jar,lib_managed/srcs/org.objenesis/objenesis/objenesis-2.1-sources.jar,lib_managed/srcs/org.apache.zookeeper/zookeeper/zookeeper-3.4.5-sources.jar,lib_managed/srcs/net.java.dev.jets3t/jets3t/jets3t-0.7.1-sources.jar,lib_managed/srcs/com.github.mpilquist/simulacrum_2.11/simulacrum_2.11-0.10.0-sources.jar,lib_managed/srcs/javax.inject/javax.inject/javax.inject-1-sources.jar,lib_managed/srcs/com.esotericsoftware/minlog/minlog-1.3.0-sources.jar,lib_managed/srcs/com.esotericsoftware/kryo-shaded/kryo-shaded-3.0.3-sources.jar,lib_managed/srcs/org.roaringbitmap/RoaringBitmap/RoaringBitmap-0.5.11-sources.jar,lib_managed/srcs/com.thoughtworks.paranamer/paranamer/paranamer-2.6-sources.jar,lib_managed/srcs/javax.validation/validation-api/validation-api-1.1.0.Final-sources.jar,lib_managed/srcs/net.sf.py4j/py4j/py4j-0.10.4-sources.jar,lib_managed/srcs/commons-io/commons-io/commons-io-2.1-sources.jar,lib_managed/srcs/org.glassfish.jersey.bundles.repackaged/jersey-guava/jersey-guava-2.22.2-sources.jar,lib_managed/srcs/oro/oro/oro-2.0.8-sources.jar,lib_managed/srcs/commons-codec/commons-codec/commons-codec-1.10-sources.jar,lib_managed/srcs/javax.ws.rs/javax.ws.rs-api/javax.ws.rs-api-2.0.1-sources.jar,lib_managed/srcs/org.codehaus.jackson/jackson-mapper-asl/jackson-mapper-asl-1.9.13-sources.jar,lib_managed/srcs/org.codehaus.jackson/jackson-core-asl/jackson-core-asl-1.9.13-sources.jar,lib_managed/srcs/org.sonatype.sisu.inject/cglib/cglib-2.2.1-v20090111-sources.jar,lib_managed/srcs/com.chuusai/shapeless_2.11/shapeless_2.11-2.3.2-sources.jar,lib_managed/srcs/net.razorvine/pyrolite/pyrolite-4.13-sources.jar,lib_managed/srcs/org.glassfish.jersey.containers/jersey-container-servlet/jersey-container-servlet-2.22.2-sources.jar,lib_managed/srcs/org.glassfish.jersey.containers/jersey-container-servlet-core/jersey-container-servlet-core-2.22.2-sources.jar,lib_managed/srcs/com.ning/compress-lzf/compress-lzf-1.0.3-sources.jar,lib_managed/srcs/org.glassfish.jersey.media/jersey-media-jaxb/jersey-media-jaxb-2.22.2-sources.jar,lib_managed/srcs/commons-collections/commons-collections/commons-collections-3.2.1-sources.jar,lib_managed/srcs/org.tukaani/xz/xz-1.0-sources.jar,lib_managed/srcs/org.fusesource.leveldbjni/leveldbjni-all/leveldbjni-all-1.8-sources.jar,lib_managed/srcs/org.scala-lang/scalap/scalap-2.11.8-sources.jar,lib_managed/srcs/org.scala-lang/scala-compiler/scala-compiler-2.11.8-sources.jar,lib_managed/srcs/org.scala-lang/scala-library/scala-library-2.11.8-sources.jar,lib_managed/srcs/org.scala-lang/scala-reflect/scala-reflect-2.11.8-sources.jar,lib_managed/srcs/org.typelevel/macro-compat_2.11/macro-compat_2.11-1.1.1-sources.jar,lib_managed/srcs/org.typelevel/cats-macros_2.11/cats-macros_2.11-0.9.0-sources.jar,lib_managed/srcs/org.typelevel/cats-kernel_2.11/cats-kernel_2.11-0.9.0-sources.jar,lib_managed/srcs/org.typelevel/cats-core_2.11/cats-core_2.11-0.9.0-sources.jar,lib_managed/srcs/org.typelevel/machinist_2.11/machinist_2.11-0.6.1-sources.jar,lib_managed/srcs/com.github.rwl/jtransforms/jtransforms-2.4.0-sources.jar,lib_managed/srcs/org.codehaus.janino/janino/janino-3.0.7-sources.jar,lib_managed/srcs/org.codehaus.janino/commons-compiler/commons-compiler-3.0.7-sources.jar,lib_managed/srcs/com.fasterxml.jackson.core/jackson-annotations/jackson-annotations-2.6.5-sources.jar,lib_managed/srcs/com.fasterxml.jackson.core/jackson-databind/jackson-databind-2.6.5-sources.jar,lib_managed/srcs/com.fasterxml.jackson.core/jackson-core/jackson-core-2.6.5-sources.jar,lib_managed/srcs/io.netty/netty-all/netty-all-4.0.43.Final-sources.jar,lib_managed/srcs/io.netty/netty/netty-3.8.0.Final-sources.jar,lib_managed/srcs/org.spire-math/jawn-parser_2.11/jawn-parser_2.11-0.10.4-sources.jar,lib_managed/srcs/org.spire-math/spire-macros_2.11/spire-macros_2.11-0.7.4-sources.jar,lib_managed/srcs/org.spire-math/spire_2.11/spire_2.11-0.7.4-sources.jar,lib_managed/srcs/org.jpmml/pmml-model/pmml-model-1.2.15-sources.jar,lib_managed/srcs/org.jpmml/pmml-schema/pmml-schema-1.2.15-sources.jar,lib_managed/srcs/org.javassist/javassist/javassist-3.18.1-GA-sources.jar,lib_managed/srcs/io.circe/circe-literal_2.11/circe-literal_2.11-0.8.0-sources.jar,lib_managed/srcs/io.circe/circe-core_2.11/circe-core_2.11-0.8.0-sources.jar,lib_managed/srcs/io.circe/circe-generic_2.11/circe-generic_2.11-0.8.0-sources.jar,lib_managed/srcs/io.circe/circe-jawn_2.11/circe-jawn_2.11-0.8.0-sources.jar,lib_managed/srcs/io.circe/circe-numbers_2.11/circe-numbers_2.11-0.8.0-sources.jar,lib_managed/srcs/commons-httpclient/commons-httpclient/commons-httpclient-3.1-sources.jar,lib_managed/srcs/org.apache.curator/curator-client/curator-client-2.4.0-sources.jar,lib_managed/srcs/org.apache.curator/curator-recipes/curator-recipes-2.4.0-sources.jar,lib_managed/srcs/org.apache.curator/curator-framework/curator-framework-2.4.0-sources.jar,lib_managed/srcs/org.glassfish.hk2/hk2-locator/hk2-locator-2.4.0-b34-sources.jar,lib_managed/srcs/org.glassfish.hk2/hk2-api/hk2-api-2.4.0-b34-sources.jar,lib_managed/srcs/org.glassfish.hk2/hk2-utils/hk2-utils-2.4.0-b34-sources.jar,lib_managed/srcs/org.glassfish.hk2/osgi-resource-locator/osgi-resource-locator-1.0.1-sources.jar,lib_managed/srcs/org.eclipse.jetty.alpn/alpn-api/alpn-api-1.1.2.v20150522-sources.jar,lib_managed/srcs/org.scodec/scodec-bits_2.11/scodec-bits_2.11-1.1.5-sources.jar,lib_managed/srcs/com.github.fommil.netlib/core/core-1.1.2-sources.jar,lib_managed/srcs/org.slf4j/jul-to-slf4j/jul-to-slf4j-1.7.16-sources.jar,lib_managed/srcs/org.slf4j/slf4j-log4j12/slf4j-log4j12-1.7.16-sources.jar,lib_managed/srcs/org.slf4j/jcl-over-slf4j/jcl-over-slf4j-1.7.16-sources.jar,lib_managed/srcs/org.slf4j/slf4j-api/slf4j-api-1.7.25-sources.jar,lib_managed/srcs/javax.annotation/javax.annotation-api/javax.annotation-api-1.2-sources.jar,lib_managed/srcs/org.apache.commons/commons-compress/commons-compress-1.4.1-sources.jar,lib_managed/srcs/org.apache.commons/commons-crypto/commons-crypto-1.0.0-sources.jar,lib_managed/srcs/org.apache.commons/commons-math/commons-math-2.1-sources.jar,lib_managed/srcs/org.apache.commons/commons-lang3/commons-lang3-3.5-sources.jar,lib_managed/srcs/org.apache.commons/commons-math3/commons-math3-3.4.1-sources.jar,lib_managed/srcs/org.glassfish.jersey.core/jersey-common/jersey-common-2.22.2-sources.jar,lib_managed/srcs/org.glassfish.jersey.core/jersey-client/jersey-client-2.22.2-sources.jar,lib_managed/srcs/org.glassfish.jersey.core/jersey-server/jersey-server-2.22.2-sources.jar,lib_managed/srcs/org.apache.parquet/parquet-common/parquet-common-1.8.1-sources.jar,lib_managed/srcs/org.apache.parquet/parquet-jackson/parquet-jackson-1.8.1-sources.jar,lib_managed/srcs/org.apache.parquet/parquet-column/parquet-column-1.8.1-sources.jar,lib_managed/srcs/org.apache.parquet/parquet-hadoop/parquet-hadoop-1.8.1-sources.jar,lib_managed/srcs/org.apache.parquet/parquet-format/parquet-format-2.3.0-incubating-sources.jar,lib_managed/srcs/org.apache.parquet/parquet-encoding/parquet-encoding-1.8.1-sources.jar,lib_managed/srcs/commons-net/commons-net/commons-net-2.2-sources.jar,lib_managed/srcs/commons-configuration/commons-configuration/commons-configuration-1.6-sources.jar,lib_managed/srcs/log4j/log4j/log4j-1.2.17-sources.jar,lib_managed/srcs/jline/jline/jline-2.12.1-sources.jar,lib_managed/srcs/org.scalamacros/paradise_2.11.8/paradise_2.11.8-2.1.0-sources.jar,lib_managed/srcs/javax.servlet/javax.servlet-api/javax.servlet-api-3.1.0-sources.jar,lib_managed/srcs/org.scala-lang.modules/scala-xml_2.11/scala-xml_2.11-1.0.5-sources.jar,lib_managed/srcs/org.scala-lang.modules/scala-xml_2.11/scala-xml_2.11-1.0.4-sources.jar,lib_managed/srcs/org.scala-lang.modules/scala-parser-combinators_2.11/scala-parser-combinators_2.11-1.0.4-sources.jar,lib_managed/srcs/org.glassfish.hk2.external/aopalliance-repackaged/aopalliance-repackaged-2.4.0-b34-sources.jar,lib_managed/srcs/org.glassfish.hk2.external/javax.inject/javax.inject-2.4.0-b34-sources.jar,lib_managed/srcs/net.sf.opencsv/opencsv/opencsv-2.3-sources.jar,lib_managed/srcs/commons-cli/commons-cli/commons-cli-1.2-sources.jar,lib_managed/srcs/com.google.guava/guava/guava-14.0.1-sources.jar,lib_managed/srcs/commons-digester/commons-digester/commons-digester-1.8-sources.jar,lib_managed/srcs/org.json4s/json4s-jackson_2.11/json4s-jackson_2.11-3.2.11-sources.jar,lib_managed/srcs/org.json4s/json4s-ast_2.11/json4s-ast_2.11-3.2.11-sources.jar,lib_managed/srcs/org.json4s/json4s-core_2.11/json4s-core_2.11-3.2.11-sources.jar,lib_managed/srcs/com.univocity/univocity-parsers/univocity-parsers-2.2.1-sources.jar,lib_managed/srcs/com.fasterxml.jackson.module/jackson-module-paranamer/jackson-module-paranamer-2.6.5-sources.jar,lib_managed/srcs/com.fasterxml.jackson.module/jackson-module-scala_2.11/jackson-module-scala_2.11-2.6.5-sources.jar,lib_managed/srcs/com.google.protobuf/protobuf-java/protobuf-java-2.5.0-sources.jar,lib_managed/srcs/com.google.inject/guice/guice-3.0-sources.jar,lib_managed/srcs/com.twitter/hpack/hpack-v1.0.1-sources.jar,lib_managed/srcs/com.twitter/chill-java/chill-java-0.8.0-sources.jar,lib_managed/srcs/com.twitter/chill_2.11/chill_2.11-0.8.0-sources.jar,lib_managed/srcs/org.apache.ivy/ivy/ivy-2.4.0-sources.jar,lib_managed/srcs/org.apache.kafka/kafka-clients/kafka-clients-0.8.2.1-sources.jar,lib_managed/srcs/org.apache.kafka/kafka_2.11/kafka_2.11-0.8.2.1-sources.jar,lib_managed/srcs/com.yammer.metrics/metrics-core/metrics-core-2.2.0-sources.jar,lib_managed/srcs/org.log4s/log4s_2.11/log4s_2.11-1.3.6-sources.jar,lib_managed/srcs/org.apache.avro/avro/avro-1.7.7-sources.jar,lib_managed/srcs/org.apache.avro/avro-ipc/avro-ipc-1.7.7-sources.jar,lib_managed/srcs/org.apache.avro/avro-mapred/avro-mapred-1.7.7-sources.jar,lib_managed/srcs/com.101tec/zkclient/zkclient-0.3-sources.jar,lib_managed/srcs/org.http4s/http4s-blaze-client_2.11/http4s-blaze-client_2.11-0.17.5-sources.jar,lib_managed/srcs/org.http4s/http4s-client_2.11/http4s-client_2.11-0.17.5-sources.jar,lib_managed/srcs/org.http4s/jawn-fs2_2.11/jawn-fs2_2.11-0.10.1-sources.jar,lib_managed/srcs/org.http4s/http4s-circe_2.11/http4s-circe_2.11-0.17.5-sources.jar,lib_managed/srcs/org.http4s/http4s-blaze-core_2.11/http4s-blaze-core_2.11-0.17.5-sources.jar,lib_managed/srcs/org.http4s/http4s-jawn_2.11/http4s-jawn_2.11-0.17.5-sources.jar,lib_managed/srcs/org.http4s/blaze-core_2.11/blaze-core_2.11-0.12.9-sources.jar,lib_managed/srcs/org.http4s/parboiled_2.11/parboiled_2.11-1.0.0-sources.jar,lib_managed/srcs/org.http4s/http4s-websocket_2.11/http4s-websocket_2.11-0.2.0-sources.jar,lib_managed/srcs/org.http4s/http4s-core_2.11/http4s-core_2.11-0.17.5-sources.jar,lib_managed/srcs/org.http4s/blaze-http_2.11/blaze-http_2.11-0.12.9-sources.jar $PATH_TO_APP_JAR
fi

