# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.9.0] - 2020-09-01
### Breaking
- upgraded required_providers format to Terraform 0.13 (compatible with Terraform >= 0.12.26)
- remove deprecated "region" attribute from aws_s3_bucket

### Added
- secure transport requirement to S3 bucket policy

## [0.8.1] - 2020-06-04
### Added
- dynamodb:DescribeTable permission
- s3:GetBucketVersioning permission

## [0.8.0] - 2020-06-02
### Added
- workspace_key_prefix variable

## [0.7.0] - 2020-04-29
### Breaking
- The `all` key in `workspace_details` has been removed. This functionality is now handled with its own variable `all_workspaces_details`

## [0.6.0] - 2020-04-29
### Added
- Tags support

## [0.5.0] - 2020-02-17
### Added
- Tests
- Optional KMS encryption for S3
- Optional unencrypted upload prevention

### Changed
- Renamed files and rearranged resources within and between files
- Renamed resouce names to use underscores instead of dashes
- Updated the Makefile to plan tests
- Docker-compose now using latest CMD image
- Combined `workspace_prefixes` and `assume_policy` into single variable and adjusted loops and lookups where needed

## [0.4.0] - 2019-08-13
### Fixed
- Fixed IAM permission to dynamoDB table (added expected prefix)

## [0.3.0] - 2019-06-03
### Breaking
- Updated code to terraform 0.12.0

### Fixed
- Added IAM permissions to allow deletion of workspaces. Fixes #2

## [0.2.0] - 2019-02-09
### Changed
- All resources are now prefixed allowing multiple backends to be deployed into the same account
- Workspaces have been changed to prefixes rather than full paths

## [0.1.0] - 2019-01-27
### Added
- Everything
