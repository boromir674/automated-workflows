# How to add a Dockerhub Publish Job

## 1. Create a Gihub Repository

## 2. Write a Dockerfile

## 3. Create an account on Dockerhub

## 4. Set the DOCKER_USER variable

## 5. Set the DOCKER_PASSWORD secret

## 6. Edit your Github Actions workflow file

## 7. Add a Docker Publish Job

Add the following `Job` into your `workflow config` yaml file, under the `jobs` document key:

```yaml
jobs:
  call_docker_job:
    needs: build_n_test
    if: always()
    uses: boromir674/automated-workflows/.github/workflows/docker.yml@v1.1.1
    with:
      DOCKER_USER: ${{ vars.DOCKER_USER }}
      acceptance_policy: 2
      image_slug: "my_app_name"
      image_tag: "1.0.0"
      tests_pass: ${{ needs.build_n_test.result == 'success' }}
      tests_run: ${{ !contains(fromJSON('["skipped", "cancelled"]'), needs.build_n_test.result) }}
    secrets:
      DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
```

## 8. Replace references with your Test Job

## 9. Run your Pipeline, by triggering the Workflow, in Github Actions
