
        === "B -> T -> D"

            ```yaml

                name: 'CI/CD 3-Phases Pipeline'
                on:
                  push:
                    branches:
                      - main
                jobs:
                  build:
                    runs-on: ubuntu-latest
                    steps:
                      - run: echo "Build Finished :)"

                  test:
                    needs: build
                    runs-on: ubuntu-latest
                    # Unit Testing
                    # Functional Testing
                    steps:
                      - run: echo "Test Finished :)"

                  deploy:
                    needs: test
                    runs-on: ubuntu-latest
                    steps:
                      - run: echo "Deploy Finished :)"

                    ### Git Ops: Check PR Acceptance ###
                  qa_signal:
                    needs: test
                    uses: boromir674/automated-workflows/.github/workflows/go-single-status.yml@ffac270355ffe73cb8ab2bd2477ce6b20efca912  # v1.7.0
                    with:
                      needs_json: {% raw %}'${{ "{{" }} toJson(needs) {{ "}}" }}'{% endraw %}
            ```

        === "B -> Parallel T -> D"

            ```yaml

                name: 'CI/CD Pipeline'
                on:
                  push:
                    branches:
                      - main
                jobs:
                  build:
                    runs-on: ubuntu-latest
                    steps:
                      - run: echo "Build Finished :)"

                  test:
                    needs: build
                    runs-on: ubuntu-latest
                    # Unit Testing
                    # Functional Testing
                    steps:
                      - run: echo "Test Finished :)"

                  integration_tests:
                    needs: build
                    runs-on: ubuntu-latest
                    steps:
                      - run: echo "Test Integration Finished :)"

                  deploy:
                    needs: [test, integration_tests]
                    runs-on: ubuntu-latest
                    steps:
                      - run: echo "Deploy Finished :)"

                    ### Git Ops: Check PR Acceptance ###
                  qa_signal:
                    needs: [test, integration_tests]
                    uses: boromir674/automated-workflows/.github/workflows/go-single-status.yml@ffac270355ffe73cb8ab2bd2477ce6b20efca912  # v1.7.0
                    with:
                      needs_json: {% raw %}'${{ "{{" }} toJson(needs) {{ "}}" }}'{% endraw %}
            ```

        === "B -> T Matrix -> D"

            ```yaml

                name: 'CI/CD Pipeline'
                on:
                  push:
                    branches:
                      - main
                jobs:
                  build:
                    runs-on: ubuntu-latest
                    steps:
                      - run: echo "Build Finished :)"

                  test:
                    needs: build
                    runs-on: ubuntu-latest
                    strategy:
                      matrix: ['py311', 'py312']
                    steps:
                      - run: echo "Test {% raw %}${{ "{{" }} strategy.matrix {{ "}}" }}{% endraw %} Finished :)"

                  integration_tests:
                    needs: build
                    runs-on: ubuntu-latest
                    steps:
                      - run: echo "Test Integration Finished :)"

                  deploy:
                    needs: [test, integration_tests]
                    runs-on: ubuntu-latest
                    steps:
                      - run: echo "Deploy Finished :)"

                    ### Git Ops: Check PR Acceptance ###
                  qa_signal:
                    needs: [test, integration_tests]
                    uses: boromir674/automated-workflows/.github/workflows/go-single-status.yml@ffac270355ffe73cb8ab2bd2477ce6b20efca912  # v1.7.0
                    with:
                      needs_json: {% raw %}'${{ "{{" }} toJson(needs) {{ "}}" }}'{% endraw %}
            ```

        === "T1 -> B -> T2 -> D"


            ```yaml

                name: 'CI/CD Pipeline'
                on:
                  push:
                    branches:
                        - main
                jobs:
                  test_1:
                    runs-on: ubuntu-latest
                    steps:
                        - run: echo "Test 1 Finished :)"

                  build:
                    needs: test_1
                    runs-on: ubuntu-latest
                    steps:
                        - run: echo "Build Finished :)"

                  test_2:
                    needs: build
                    runs-on: ubuntu-latest
                    strategy:
                      matrix: ['py311', 'py312']
                    steps:
                      - run: echo "Test {% raw %}${{ "{{" }} strategy.matrix {{ "}}" }}{% endraw %} Finished :)"

                  deploy:
                    needs: test_2
                    runs-on: ubuntu-latest
                    steps:
                      - run: echo "Deploy Finished :)"

                    ### Git Ops: Check PR Acceptance ###
                  qa_signal:
                    needs: [test_1, test_2]
                    uses: boromir674/automated-workflows/.github/workflows/go-single-status.yml@ffac270355ffe73cb8ab2bd2477ce6b20efca912  # v1.7.0
                    with:
                      needs_json: {% raw %}'${{ "{{" }} toJson(needs) {{ "}}" }}'{% endraw %}
            ```

        > Above shorthands `B`, `T`, `D` correspond to typical `Build`, `Test`, `Deploy` CI/CD Jobs
