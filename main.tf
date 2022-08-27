provider "aws" {
  region = var.region
}

###SAMPLE
module "sample" {
  source  = "./modules/sample"
}

### END SAMPLE
