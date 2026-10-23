# AWS OIDC and ECR publishing setup

This guide is for the GitHub Actions publishing job in `.github/workflows/ci.yml`. The CI validation job does not need AWS credentials and should remain usable even if publishing is disabled.

## 1. Confirm the account and OIDC provider

The checked-in workflow has historically used AWS account `990787030729`, region `ap-south-1`, and role name `GitHubActionsECRPushRole`. **Verify these values in your own AWS console before editing anything.** Do not use a policy for the wrong account.

In IAM → Identity providers, confirm that an OIDC provider exists for:

- Provider URL: `https://token.actions.githubusercontent.com`
- Audience/client ID: `sts.amazonaws.com`

Create it only if it is missing and you are authorized to manage IAM.

## 2. Compare the role trust policy

The exact subject expected for a push/manual workflow dispatch on `main` is based on the current GitHub owner and repository IDs:

```text
repo:nagateja-2002@259488259/eks-production-platform@1359044628:ref:refs/heads/main
```

GitHub now issues immutable owner/repository IDs in the default `sub` claim for repositories created after 15 July 2026. A mismatch between the role's `token.actions.githubusercontent.com:sub` condition and the claim emitted by GitHub can cause `Not authorized to perform sts:AssumeRoleWithWebIdentity`.

A repository-scoped example is in [aws-oidc-trust-policy.json](aws-oidc-trust-policy.json). Merge the statement into the existing role trust policy, or replace it only after confirming the role is dedicated to this workflow. Do not blindly overwrite trust relationships used by other approved workloads.

## 3. Check ECR permissions

An example least-privilege push policy is in [aws-ecr-push-policy.json](aws-ecr-push-policy.json). It grants authentication plus image-push actions for the single ECR repository. Verify that the repository exists in `ap-south-1` and that the account ID matches the one you intend to use.

## 4. Configure GitHub repository variables

In GitHub → repository Settings → Secrets and variables → Actions → Variables, set:

- `AWS_ROLE_TO_ASSUME`: the verified role ARN, for example `arn:aws:iam::990787030729:role/GitHubActionsECRPushRole`.
- `ENABLE_ECR_PUBLISH`: set to `true` only after the trust policy and permissions are verified. Leave unset/false to keep publishing disabled.

The publishing job already requests `id-token: write` and `contents: write` only within that job. Confirm that repository rules and Actions settings permit its workflow token to update `helm/eks-production-platform/values.yaml`.

## 5. Test safely

1. Keep publishing disabled until the IAM configuration is ready.
2. Check the [latest CI run](https://github.com/nagateja-2002/eks-production-platform/actions) and confirm the validation job passes.
3. Enable `ENABLE_ECR_PUBLISH=true`.
4. From Actions, run workflow `CI` on `main` with `publish_image=true`.
5. Verify OIDC authentication, ECR image push, and the resulting Helm image URI/tag update.
6. Verify that Argo CD synchronizes the intended app and that the deployed image becomes healthy before calling it deployed.

**No live AWS resource changes are made by these files.** They are examples to review and apply in your AWS account. A successful Terraform validation does not prove AWS IAM trust, ECR permissions, cluster availability, or application deployment.
