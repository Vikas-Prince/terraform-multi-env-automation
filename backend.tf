terraform{
    backend "s3"{
        bucket = "vikas-multi-env-bucket"
        key = "terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
    }
}