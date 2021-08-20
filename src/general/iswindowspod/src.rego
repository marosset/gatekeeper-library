package iswindowspod

default is_windows_pod = false

is_windows_pod = true {
    is_windows_pod_internal
}

# returns true if input spec has a nodeSelector matching kubernetse.io/os = windows.
is_windows_pod_internal {
    ns := input.review.object.spec.nodeSelector
    ns["kubernetes.io/os"] == "windows"
}

# returns true if spec specifies one of the Windows runtime class names specified in the constraint.
is_windows_pod_internal {
    rcn := input.review.object.spec.runtimeClassName
    input.parameters.windowsRuntimeClassNames[_] == rcn
}
