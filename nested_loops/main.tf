locals {
  rbac = {
    topic = {
      "my-first-topic" = [
        {
          role = "roles/pubsub.publisher"
          account_ids = [
            "user:my-sa-001@myfirstproject.iam.gserviceaccount.com",
            "user:my-sa-004@myfirstproject.iam.gserviceaccount.com"
          ]
        },
        {
          role = "roles/pubsub.subscriber"
          account_ids = [
            "user:my-sa-003@myfirstproject.iam.gserviceaccount.com",
            "user:my-sa-004@myfirstproject.iam.gserviceaccount.com"
          ]
        }
      ],
    },
    cloudrun = {
      "my-first-cloud-run" = [
        {
          role = "roles/run.invoker"
          account_ids = [
            "user:my-sa-001@myfirstproject.iam.gserviceaccount.com"
          ]
        }
      ]
    },
    bigtable = {
      "my-first-bigtable" = [
        {
          role = "roles/bigtable.user"
          account_ids = [
            "user:my-sa-002@myfirstproject.iam.gserviceaccount.com",
            "user:my-sa-003@myfirstproject.iam.gserviceaccount.com",
            "user:my-sa-004@myfirstproject.iam.gserviceaccount.com"
          ]
        }
      ]
    }
    firestore = {
      "my-first-firestore" = [
        {
          role = "roles/datastore.user"
          account_ids = [
            "user:my-sa-003@myfirstproject.iam.gserviceaccount.com"
          ]
        }
      ]
    }
    dataset = {
      "my-first-dataset" = [
        {
          role = "roles/bigquery.dataEditor"
          account_ids = [
            "user:my-sa-003@myfirstproject.iam.gserviceaccount.com",
            "user:my-sa-004@myfirstproject.iam.gserviceaccount.com"
          ]
        }
      ]
    }
    artifactregistry = {
      "my-first-ar" = [
        {
          role = "roles/artifactregistry.repoAdmin"
          account_ids = [
            "user:my-sa-005@myfirstproject.iam.gserviceaccount.com"
          ]
        }
      ]
    }
    bucket = {
      "myfirstbucket001" = [
        {
          role = "roles/storage.objectUser"
          account_ids = [
            "user:my-sa-004@myfirstproject.iam.gserviceaccount.com"
          ]
        }
      ],
      "myfirstbucket002" = [
        {
          role = "roles/storage.objectUser"
          account_ids = [
            "user:my-sa-004@myfirstproject.iam.gserviceaccount.com"
          ]
        }
      ],
      "myfirstbucket003" = [
        {
          role = "roles/storage.objectUser"
          account_ids = [
            "user:my-sa-004@myfirstproject.iam.gserviceaccount.com",
            "user:my-sa-005@myfirstproject.iam.gserviceaccount.com"
          ]
        }
      ]
    }
    project = {
      "myfirstproject" = [
        {
          role = "roles/viewer"
          account_ids = [
            "group:mygroup@myorg.org"
          ]
        },
        {
          role = "roles/monitoring.viewer"
          account_ids = [
            "group:mygroup@myorg.org"
          ]
        },
        {
          role = "roles/logging.viewer"
          account_ids = [
            "group:mygroup@myorg.org"
          ]
        },
        {
          role = "roles/logging.privateLogViewer"
          account_ids = [
            "group:mygroup@myorg.org"
          ]
        },
      ]
    }
  }

  rbacs = { for elem in flatten([
    for rbac_type, rbac_ressource in local.rbac : [
      for resource_name, resource_rbacs in rbac_ressource : [
        for rbac in resource_rbacs : [
          for account in rbac.account_ids : {
            role          = rbac.role
            resource_name = resource_name
            account       = account
            resource_type = rbac_type
          }
        ]
      ]
    ]
  ]) : "${elem.resource_name}_${elem.account}_${elem.role}" => elem }

  topic_rbacs            = { for k, v in local.rbacs : k => v if v.resource_type == "cloudrun" }
  cloudrun_rbacs         = { for k, v in local.rbacs : k => v if v.resource_type == "topic" }
  bigtable_rbacs         = { for k, v in local.rbacs : k => v if v.resource_type == "bigtable" }
  firestore_rbacs        = { for k, v in local.rbacs : k => v if v.resource_type == "firestore" }
  dataset_rbacs          = { for k, v in local.rbacs : k => v if v.resource_type == "dataset" }
  artifactregistry_rbacs = { for k, v in local.rbacs : k => v if v.resource_type == "artifactregistry" }
  bucket_rbacs           = { for k, v in local.rbacs : k => v if v.resource_type == "bucket" }
  project_rbacs          = { for k, v in local.rbacs : k => v if v.resource_type == "project" }

}
