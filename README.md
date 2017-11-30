# Ubuntu Desktop Dockerfile

此分支用于部署至Bluemix-cf

# 配置文件推荐
---
applications:  
 -name: <app_name>  
   instances: 1  
   memory: 512M  
   disk_quota: 2048M  
   docker:  
    image: winstonpro/ubuntu-desktop:bluemix-cf
