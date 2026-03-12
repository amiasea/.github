# Look for all VNets in the Subscription
data "azurerm_resources" "existing_vnets" {
  type = "Microsoft.Network/virtualNetworks"
}

locals {
  # 1. Filter for your naming convention
  amiasea_vnets = [
    for r in data.azurerm_resources.existing_vnets.resources : r 
    if length(regexall("^vnet-amiasea-", r.name)) > 0
  ]

  # 2. Extract the second octet (assuming 10.X.0.0/16)
  # This uses a regex to grab the 'X' from '10.X.0.0/16'
  existing_octets = [
    for v in local.amiasea_vnets : 
    tonumber(split(".", v.address_space[0])[1])
  ]

  # 3. Find the Max and Increment by 1
  # If no VNets exist, start at 0
  next_octet = length(local.existing_octets) > 0 ? max(local.existing_octets...) + 1 : 0
  
  vended_cidr = "10.${local.next_octet}.0.0/16"
}