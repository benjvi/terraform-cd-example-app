
module "postgres_db" {
  source           = "./terraform-google-sql-db"
  name             = "${local.db_instance_name}"
  count = "${var.module_count}"
  region = "${local.gcp_region}"
  database_version = "POSTGRES_9_6"
}

resource "google_service_account" "sql_proxy" {
  count  = "${var.module_count}"
  account_id = "cloud-sql-proxy-${var.namespace}"
  display_name = "terraform-cicd-example-app Cloud SQL proxy"
}

resource "google_project_iam_binding" "sql_proxy" {
  count  = "${var.module_count}"
  project = "${local.gcp_project}" 
  role        = "roles/cloudsql.client"
  members = ["serviceAccount:${google_service_account.sql_proxy.email}"]
}

resource "google_service_account_key" "sql_proxy" {
  count  = "${var.module_count}"
  service_account_id = "${google_service_account.sql_proxy.id}"
}

resource "kubernetes_secret" "cloudsql-instance-credentials" {
  count  = "${var.module_count}"
  metadata {
    name = "cloudsql-instance-credentials"
    namespace = "${var.namespace}"
  }
  data {
    credentials.json = "${base64decode(google_service_account_key.sql_proxy.private_key)}"
  }
}

resource "kubernetes_secret" "cloudsql-db-credentials" {
  count  = "${var.module_count}"
  metadata {
    name = "cloudsql-db-credentials"
    namespace = "${var.namespace}"
  }
  data {
    username = "default" # default from sql-db module
    password = "${module.postgres_db.generated_user_password}"
  }
}
