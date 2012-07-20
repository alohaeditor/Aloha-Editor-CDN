Aloha-Editor-CDN
================

Aloha Editor CDN Project

This is the Aloha Editor Maven CDN Deployment Project.


Steps:
* The maven project will download all listed maven artifacts of aloha and extract them into target/cdn
* The cleanup script will prepare the contents of the zipfiles for cdn deployment
* The synchronize script will synchronize the files to the cloudfront CDN server

The credentials that are provided are fake credentials. Please use a maven profile for custom credentials.
