#### Resource Group and Kubernetes ####
variable "name" {
  type = string
}

variable "orchestrator_version" {

  type    = string
  default = "1.29.4"

}

variable "kubernetes_version" {
  type    = string
  default = "1.29.4"
}

variable "location" {
  type    = string
  default = "westeurope"

}

variable "enable_aad_rbac" {
  type        = bool
  default     = true
  description = "Is Role Based Access Control based on Azure AD enabled?"

}

variable "admin_list" {
  type        = list(string)
  default     = []
  description = "If rbac is enabled, the default admin will be set over aad groups"

}

variable "local_account_disabled" {
  type        = bool
  default     = false
  description = <<-EOT
  If true local accounts will be disabled. Defaults to false.
  When deploying an AKS Cluster, local accounts are enabled by default.
  Even when enabling RBAC or Azure Active Directory integration, --admin access still exists, essentially as a non-auditable backdoor option.
  With this in mind, AKS offers users the ability to disable local accounts via a flag, disable-local-accounts.
  A field, properties.disableLocalAccounts, has also been added to the managed cluster API to indicate whether the feature has been enabled on the cluster.
  See the documentation for more information:  https://docs.microsoft.com/azure/aks/managed-aad#disable-local-accounts"
  EOT
}

variable "load_balancer_sku" {
  type        = string
  default     = "basic"
  description = "Specifies the SKU of the Load Balancer used for this Kubernetes Cluster. Possible values are basic and standard. Defaults to standard"
}


variable "azure_cloud_zone" {

  type = string

}


variable "vm_size" {

  type    = string
  default = "Standard_B4ms"

}

variable "max_pods_per_node" {
  type    = number
  default = 45
}

variable "node_pool_max_surge" {
  type        = string
  default     = "30%"
  description = "(Required) The maximum number or percentage of nodes which will be added to the Node Pool size during an upgrade."

}

variable "node_pool_count" {

  type = number
}

variable "lock_name" {
  type        = string
  description = "Specifies the name of the Management Lock. Changing this forces a new resource to be created."
  default     = "delete lock on resource-group-level"
}

variable "lock_level" {
  type        = string
  description = "Specifies the Level to be used for this Lock. Possible values are CanNotDelete and ReadOnly. Changing this forces a new resource to be created."
  default     = "CanNotDelete"
}

variable "notes" {
  type        = string
  description = "Specifies some notes about the lock. Maximum of 512 characters. Changing this forces a new resource to be created."
  default     = "Locked, if you want remove the resourcegroup or a resource in this group, you must delete the lock first"
}

variable "authorized_ip_ranges" {

  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = <<-EOT
    Set of authorized IP ranges to allow access to API server, e.g. ["198.51.100.0/24"].
    EOT
}

variable "network_plugin" {

  type    = string
  default = "azure"

}

variable "network_policy" {

  type    = string
  default = "calico"
}

variable "azure_policy_enabled" {
  type        = bool
  default     = true
  description = "Enable Azure Policy on the Kubernetes Cluster"

}

variable "enable_node_pools" {

  type        = bool
  default     = false
  description = "Allow you to enable node pools"

}


variable "node_pools" {
  type = map(object({
    name                   = string
    vm_size                = string
    zones                  = list(string)
    enable_auto_scaling    = bool
    enable_host_encryption = bool
    enable_node_public_ip  = bool
    max_pods               = number
    node_labels            = map(string)
    node_taints            = list(string)
    os_disk_size_gb        = string
    max_count              = number
    min_count              = number
    max_surge              = string
    node_count             = number
  }))

  description = <<-EOT
    If the default node pool is a Virtual Machine Scale Set, you can define additional node pools by defining this variable.
    As of Terraform 1.0 it is not possible to mark particular attributes as optional. If you don't want to set one of the attributes, set it to null.
  EOT

  default = {}
}

variable "oidc_issuer_enabled" {
  type        = bool
  default     = false
  description = "Is OIDC issuer enabled? If true, the OIDC issuer will be enabled with Azure AD."

}

variable "workload_identity_enabled" {
  type        = bool
  default     = false
  description = "Is Workload Identity enabled? If true, the Workload Identity will be enabled with Azure AD. Require OIDC issuer enabled."

}



########## Azure Key Vault ##########
variable "network_acls" {

  type = object({
    bypass                     = string,
    default_action             = string,
    ip_rules                   = list(string),
    virtual_network_subnet_ids = list(string),
  })

  default = {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  description = "(Optional) A network_acls block as defined below"

}

variable "key_vault_admin_object_ids" {
  type        = list(string)
  description = "Optional list of object IDs of users or groups who should be Key Vault Administrators. Should only be set, if enable_rbac_authorization is set to true."
  default     = []
}

variable "role_definition_name" {
  type        = string
  description = "The Scoped-ID of the Role Definition. Changing this forces a new resource to be created. Conflicts with role_definition_name"
  default     = "Key Vault Administrator"
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
  default     = true
}


variable "key_vault_name" {
  type        = string
  description = "Specifies the name of the Key Vault. Changing this forces a new resource to be created."
}


#### Additional Variables ####
variable "tags" {
  type = map(string)
  default = {
    TF-Managed = "true"
  }
}
