terraform {
  required_version = ">= 0.12.0"

  required_providers {
    helm       = ">= 1.2.0"
    kubernetes = ">= 1.13.3"
  }
}
//
//terraform {
//  required_providers {
//    google           = ">= 3.46.0"
//    google-beta      = ">= 3.46.0"
//    kubernetes       = ">= 1.13.3"
//    kubernetes-alpha = ">= 0.2.0"
//  }
//}
