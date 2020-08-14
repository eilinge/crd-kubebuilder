# crd-kubebuilder

## build

*run*
make
make install # install crd
make run # start controller

*把controller部署到集群中*

make docker-build # build image of controller
make docker-push
make deploy # set image of controller deployment

## work flow

`make && make install && make run`

1. *add fields*

```
api/v1/virtulmachine_types.go

// VirtulMachineSpec defines the desired state of VirtulMachine
// 在这里加信息
type VirtulMachineSpec struct {
    // INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
    // Important: Run "make" to regenerate code after modifying this file
    CPU    string `json:"cpu"`   // 这是我增加的
    Memory string `json:"memory"`
}

// VirtulMachineStatus defines the observed state of VirtulMachine
// 在这里加状态信息，比如虚拟机是启动状态，停止状态啥的
type VirtulMachineStatus struct {
    // INSERT ADDITIONAL STATUS FIELD - define observed state of cluster
    // Important: Run "make" to regenerate code after modifying this file
}
```

2.1 *change controller flow*

```
vim config/controller/virtulmachine_controller.yaml

func (r *VirtulMachineReconciler) Reconcile(req ctrl.Request) (ctrl.Result, error) {
    ctx = context.Background()
    _ = r.Log.WithValues("virtulmachine", req.NamespacedName)

    vm := &v1.VirtulMachine{}
    if err := r.Get(ctx, req.NamespacedName, vm); err != nil { # 获取VM信息
        log.Error(err, "unable to fetch vm")
    } else {
        fmt.Println(vm.Spec.CPU, vm.Spec.Memory) # 打印CPU内存信息
    }

    return ctrl.Result{}, nil
}
```

2.2 *make && make install && make run*

start controller

3. *viwer crd*

kustomize build config/default
or cat config/crd/bases/seven.seven.com_.yaml

4. *deploy crd*

edit config/samples/seven_v1_virtulmachine.yaml
kubectl apply -f config/samples

5. *viwer log and crd ymal*

kubectl get virtulmachines.seven.seven.com virtulmachine-seven -o yaml

## kustomize

kustomize build config/default

ls config/webhook
- kustomization.yaml
- kustomizationconfig.yaml
- service.yaml

## go test

go test controllers/suite_test.go  -run=TestAPIs -v

## related blog

[kubebuilder](https://book.kubebuilder.io/)
[深入解析 Kubebuilder：让编写 CRD 变得更简单](https://www.cnblogs.com/alisystemsoftware/p/11580202.html)
[使用kubebuilder开发kubernetes CRD](https://segmentfault.com/a/1190000019892302)
[kubebuilder(1)-安装和使用](https://www.jianshu.com/p/de4dd9c9ad47)
[kubebuilder(2)-原理](https://www.jianshu.com/p/33ddd445b468)