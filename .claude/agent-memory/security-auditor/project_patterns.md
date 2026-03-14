---
name: project_security_patterns
description: Recurring security patterns and findings discovered across reviews of this portfolio-site S3+CloudFront Terraform infrastructure
type: project
---

## Project: portfolio-site (S3 + CloudFront static site)

### Confirmed Good Patterns (do not re-flag as issues)
- S3 public access block: all four flags enabled (block_public_acls, block_public_policy, ignore_public_acls, restrict_public_buckets = true)
- CloudFront uses OAC (not legacy OAI) — `aws_cloudfront_origin_access_control` with sigv4 + always signing
- S3 bucket policy scoped to single CloudFront distribution ARN via `AWS:SourceArn` condition
- CloudFront `viewer_protocol_policy = "redirect-to-https"`
- IAM policy for S3 bucket policy uses `s3:GetObject` only (no wildcard actions)
- No hardcoded credentials in Terraform source files (.tf)
- Bucket name uses `data.aws_caller_identity.current.account_id` — account ID not hardcoded in source
- IPv6 enabled on CloudFront
- Compression enabled on CloudFront

### Recurring Findings (check on every audit)
1. **terraform.tfstate committed to version control** — contains live account ID (772856498853), CloudFront distribution ID (EA09PBKJQKGMV), S3 bucket names, domain names (d1rfniulcghkiw.cloudfront.net). CRITICAL. State must be migrated to S3 backend.
2. **CloudFront TLS minimum protocol version is TLSv1** — confirmed in state: `minimum_protocol_version = "TLSv1"`. Requires custom ACM cert to enforce TLSv1.2_2021.
3. **No CloudFront response headers policy** — `response_headers_policy_id = ""` in state. Security headers (CSP, X-Frame-Options, HSTS, X-Content-Type-Options, X-XSS-Protection) are absent.
4. **No CloudFront access logging** — `logging_config = []` in state.
5. **No S3 server access logging** — `logging = []` in state.
6. **S3 versioning disabled** — `versioning.enabled = false` in state.
7. **No WAF Web ACL** — `web_acl_id = ""` in state.
8. **Terraform backend is commented out** — state is local, not in S3 with DynamoDB locking. backend.tf contains the config but it is entirely commented out.
9. **S3 encryption uses AES256 (SSE-S3), not SSE-KMS** — `sse_algorithm = "AES256"`, `kms_master_key_id = ""`. No customer-managed key.
10. **No OIDC / IAM role in terraform/** — GitHub Actions OIDC role not defined; CI/CD auth posture cannot be reviewed from these files.
11. **HTTP/2 only** — `http_version = "http2"` in state. http2and3 would add HTTP/3 (QUIC) support but is not a security finding per se.
12. **403 mapped to 200 + index.html** — custom_error_response maps 403 to 200. Masks S3 access-denied errors. Acceptable for SPA but worth noting for incident response.

### Account / Infrastructure Identifiers Exposed in State File
- AWS account ID: 772856498853
- CloudFront distribution ID: EA09PBKJQKGMV
- CloudFront domain: d1rfniulcghkiw.cloudfront.net
- S3 bucket: portfolio-site-production-772856498853
- OAC ID: E3EMDXW3E47AJD
- Lineage UUID: 16c60532-2b7f-f5f2-0d0a-9acda1109a44

### Audit History
- 2026-03-14: Full audit performed. All 10 recurring findings confirmed present. No new findings added vs prior session.
- 2026-03-14 (second run): Full audit repeated on same codebase. All 12 recurring findings confirmed still present in both source (.tf files) and live state (terraform.tfstate). No new findings discovered. State file serial is 6; terraform version 1.14.6.
