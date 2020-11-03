# test with GCP

## Infra

Configure gcloud cli for using project

- `gcloud init`

Create service account with following permitions:

- Project Owner
- Project Editor

```shell
gcloud iam service-accounts create <service_account_name>
gcloud projects add-iam-policy-binding <project_name> --member serviceAccount:<service_account_name>@<project_name>.iam.gserviceaccount.com --role roles/owner
gcloud projects add-iam-policy-binding <project_name> --member serviceAccount:<service_account_name>@<project_name>.iam.gserviceaccount.com --role roles/editor
```

Create service account key (json) save it in `infra` directori with name **`credentials.json`**

```shell
cd infra
gcloud iam service-accounts keys create credentials.json --iam-account=<service_account_name>@<project_name>.iam.gserviceaccount.com
```

Create storage bucket with uniq name and provide it in `var.tf`

```shell
gsutil mb -p <project_name> -c regional -l <location> gs://<bucket_name>/
```

this is need to store tfstate in bucket and share it with teammembers, if you dont whant this feature pls edit `infra/main.tf` and comment following lines:

```shell
    bucket      = "tf-ops-bucket"
    prefix      = "tf/state"
    credentials = "./credentials.json"
```

Enable Google APIs:

- `gcloud services enable compute.googleapis.com`
- `gcloud services enable servicenetworking.googleapis.com`
- `gcloud services enable cloudresourcemanager.googleapis.com`
- `gcloud services enable container.googleapis.com`

### **IMPORTANT** Update **`resources.tf`** and **`var.tf`** according to your needs

Prepare infra with terraform:

```shell
terraform init
terraform plan
terraform apply
```

## K8S

```shell
alias k=kubectl
k create ns flux
```

Create ssh deploy key for flux:

  1. Generate a SSH key named identity:
      ssh-keygen -q -N "" -f ./identity
  2. Create a Kubernetes secret:
      kubectl -n flux create secret generic flux-ssh --from-file=./identity
    2a. The SSH key will be stored in a data key matching the file name.
      Set the `git.secretDataKey` value below to change the data key if you want to use a different source file.
  3. Don't check these key files into your Git repository! Once you've created the Kubernetes secret, Delete the private key:
      rm ./identity
  4. Add ./identity.pub as a deployment key with write access in your Git repo
  5. Set the secret name (flux-ssh) below

Install helm:

- `https://helm.sh/docs/intro/install/`

Install flux via helm with:

```shell
cd k8s/charts
helm install -f flux/values.yaml flux flux --namespace flux
helm install -f flux-helm-operator/values.yaml flux-helm-operator flux-helm-operator --namespace flux
```

Changes for flux resiurses can be found in `k8s/releases`.

Check new available ip's with

```shell
k get svc -n infrastructure
```

check answer from default backend

```shell
curl -v http://<external_ip_address>
```
