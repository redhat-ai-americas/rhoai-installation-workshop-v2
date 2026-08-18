# Iris Pipeline

Sample Kubeflow pipeline for Iris classification training and evaluation.

## Documentation

- [Build, schedule, and track machine learning pipelines](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/working_with_ai_pipelines/index)
- [Configuring a pipeline server](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html-single/working_with_ai_pipelines/index#configuring-a-pipeline-server)

## Source

This pipeline was rendered from the Kubeflow example located in the [kubeflow-pipelines-examples](https://github.com/redhat-ai-services/kubeflow-pipelines-examples/blob/main/pipelines/11_iris_training_pipeline.py) repository.

```bash
oc apply -k configs/07-ai-pipelines/03-iris-pipeline
```
