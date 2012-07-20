#!/bin/bash
java -classpath $(echo target/jets3t/*.jar | tr ' ' ':')  org.jets3t.apps.synchronize.Synchronize --batch --properties target/aws/aws.s3.synchronize.properties UP alohaeditor target/cdn/*
