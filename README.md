# registry on k3s

快速在 K3s 上运行代理仓库，主要用于解决 gcr.io、k8s-gcr.io 等仓库访问不了的问题。

## 说明

- 该仓库内容参考了 [云原生实验室](https://fuckcloudnative.io/) 的博客: [Docker 镜像加速教程](https://fuckcloudnative.io/posts/docker-registry-proxy/)，感谢该博客提供的完善教程。
- 默认使用了 云原生实验室 打包好的镜像: `yangchuansheng/registry-proxy:latest`，可自行使用 Dockerfile, entrypoint 打包出自己的镜像

## 使用

1. 拥有一台可以访问 gcr.io, k8s-gcr.io... 并且有公网 IP 的机器
2. 在机器上拉取本仓库: `git clone https://github.com/eightpigs/proxy_registry_k3s`
3. 根据代理情况修改 `run.sh` 的前几行配置，默认创建 hub.docker.io, gcr.io, k8s-gcr.io 3个代理

   如果要代理 **hub.docker.io** 请自行更换以下信息:
   - UserName : `pod-hub-registry.yaml:72`
   - Password: `pod-hub-registry.yaml:74`

4. 运行: `./run.sh`，运行结束后会有如下输出表示相关仓库配置成功: 

  ```shell
  hub-k3s.io => HTTP/1.1 200 OK
  gcr-k3s.io => HTTP/1.1 200 OK
  k8s-gcr-k3s.io => HTTP/1.1 200 OK
  ```

5. 使用 ansible 对自有 K3s 集群的所有节点配置代理

   - 记得在 `$ANSIBLE_INVENTORY` 中配置 k3s 相关 hosts
   - 运行过程中，会询问 第一步 服务器的公网IP，填入即可

  ```shell
    ansible-playbook ansible-add-registry.yaml -K
  ```
6. **Enjoy it**
