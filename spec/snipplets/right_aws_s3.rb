require 'rubygems'
require 'yaml'
require 'right_aws'

s3_config = YAML.load_file('/etc/gocool/s3.yml')
s3 = RightAws::S3.new(s3_config['aws_access_key'], s3_config['aws_secret_access_key'])
bucket1 = s3.bucket('gocool_uploads_test')
puts bucket1.keys  #=> exception here if the bucket does not exists
