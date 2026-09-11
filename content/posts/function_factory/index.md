+++
date = '2026-09-11T11:27:31+08:00'
draft = true
title = 'Function_factory'
+++

# 函数工厂 模式

函数工厂指的是根据输入来返回相应的函数的函数， 也就是说这个函数的返回值就是一个函数。
因为它是生产函数的， 所以我们称作函数工厂

这里举一个 `golang` 的例子， 函数工厂可以让我们的函数更加灵活，并且很多时候可以组合出类似 `io.MultiWriter` 的东西

- 定义结构体

这里的重点就是 EnergyRequirement, 我们将针对这个特征来构建函数工厂

```go
type Work struct {
 // Use timestamp hash as id
 // Auto generated
 ID string `toml:"id"`

 // Title provide overview information for work dependency reference
 // NOTE: User set
 Title string `toml:"title"`

 // EnergyRequirement mark the suitable status for handling this work
 // NOTE: User set
 EnergyRequirement Energy `toml:"energy"`

 // Auto generated
 // default StatusTODO
 Status WorkStatus `toml:"work_status"`
}
```

- 定义函数类型

```go
type WorkFilter func(*models.Work) bool
```

这里我们定义了一个函数类型， 它的输入是一个 models.Work 的指针， 然后返回 bool 类型， 表示是否符合条件

- 实现函数工厂

函数工厂在大多数时候需要满足处理和判断的逻辑都相同

针对 `EnergyRequirement` 这个字段， 我们进行相同的逻辑判断, 因此我们可以实现一个工厂

```go
func EnergyFilter (e models.Energy) WorkFilter {
    return func (w *models.Work) bool {
        return w.EnergyRequirement == e
    }
}
```

我们根据需要输入对应的 Energy 就可以生成一个判断函数

但是单纯这样并不能发挥出它的作用。

真正的精髓在于**将多个函数组合成一个函数**

```go
func MultiFilter(filters ...WorksFilter) WorksFilter {
    return func(w *models.Work) bool {
        for _, f := range filters {
            if !f(w) {
                return false
            }
        }

        return true
    }
}
```

在 golang 的标准库中， 使用接口的模式也可以实现这种组合的效果， 可以查看 [golang io package](https://pkg.go.dev/io#MultiWriter) 当中的 MultiWriter 函数
