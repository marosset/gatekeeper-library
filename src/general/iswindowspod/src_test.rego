package iswindowspod

test_no_nodeselector_no_runtimeclassname {
    input := {
        "review": make_review(null, null),
        "parameters": {"windowsRuntimeClassNames": []}
    }
    r := is_windows_pod with input as input
    r == false
}

test_no_nodeselector_no_runtimeclassname {
    input := {
        "review": make_review(null, null),
        "parameters": {"windowsRuntimeClassNames": ["runhcs-wcow-process"]}
    }
    r := is_windows_pod with input as input
    r == false
}

test_linux_nodeselector_no_runtimeclassname {
    input := {
        "review": make_review(linuxNodeSelctor, null),
        "parameters": {"windowsRuntimeClassNames": ["runhcs-wcow-process"]}
    }
    r := is_windows_pod with input as input
    r == false
}

test_no_nodeselector_other_runtimeclassname {
    input := {
        "review": make_review(null, "fooRuntimeClass"),
        "parameters": {"windowsRuntimeClassNames": []}
    }
    r := is_windows_pod with input as input
    r == false
}

test_no_nodeselector_other_runtimeclassname {
    input := {
        "review": make_review(null, "fooRuntimeClass"),
        "parameters": {"windowsRuntimeClassNames": ["runhcs-wcow-process", "windows-server-2019"]}
    }
    r := is_windows_pod with input as input
    r == false
}

test_windows_nodeselector_no_runtimeclassname {
    input := {
        "review": make_review(null, null),
        "parameters": {"windowsRuntimeClassNames": ["runhcs-wcow-process"]}
    }
    r := is_windows_pod with input as input
    r == false
}

test_no_nodeselector_windows_runtimeclassname {
    input := {
        "review": make_review(null, "windows-server-2019"),
        "parameters": {"windowsRuntimeClassNames": ["runhcs-wcow-process", "windows-server-2019"]}
    }
    r := is_windows_pod with input as input
    r == true
}

test_windows_nodeselector_windows_runtimeclassname {
    input := {
        "review": make_review(windowsNodeSelector, "windows-server-2019"),
        "parameters": {"windowsRuntimeClassNames": ["runhcs-wcow-process", "windows-server-2019"]}
    }
    r := is_windows_pod with input as input
    r == true
}

make_review(nodeSelector, runtimeClassName) = out {
    node_selector_obj := obj_if_exists("nodeSelector", nodeSelector)
    runtime_class_name_obj := obj_if_exists("runtimeClassName", runtimeClassName)
    out = {
        "object": {
            "kind": "Pod",
            "metadata" : {
                "name": "test-pod"
            },
            "spec": object.union(node_selector_obj, runtime_class_name_obj)
        }
    }
}

obj_if_exists(key, val) = out {
    not is_null(val)
    out := { key : val }
}

obj_if_exists(key, val) = out {
    is_null(val)
    out := {}
}

linuxNodeSelctor = out {
    out = {
        "kubernetes.io/os": "linux"
    }
}

windowsNodeSelector = out {
    out = {
        "kubernetes.io/os": "windows"
    }
}
