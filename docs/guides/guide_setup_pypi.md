# How to add a PyPI Publish Job

## 1. Create a Gihub Repository

## 2. Create a Python Package

## 3. Create accounts on PyPI and PyPI Test

## 4. Create Environments PYPI_PROD and PYPI_TEST

## 6. Edit your Github Actions workflow file

## 7. Add a PyPI Publish Job

Add the following `Job` into your `workflow config` yaml file, under the `jobs` document key:

{% raw %}
```yaml
jobs:
  pypi_publ:
    needs: test_job
    name: PyPI Upload
    uses: boromir674/automated-workflows/.github/workflows/pypi_env.yml@v1.1.2
    with:
      distro_name: "my_python_package_name"
      distro_version: "1.0.0"
      should_trigger: ${{ "{{" }} vars.AUTOMATED_DEPLOY != 'false' {{ "}}" }}
      pypi_env: "PYPI_TEST"
      artifacts_path: distro_artifacts
      require_wheel: false
      allow_existing: true
    secrets:
      TWINE_PASSWORD: ${{ "{{" }} secrets.TWINE_PASSWORD {{ "}}" }}
```
{% endraw %}

## 8. Replace `test_job` reference with your Test Job

## 9. Replace `distro_artifacts` with python distro artifacts of your Test Job

## 9. Run your Pipeline, by triggering the Workflow, in Github Actions
