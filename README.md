Etapas do Processo de Teste, Build e Deploy

#### Secrets
Variaveis de ambiente do GitHub
  - DOCKER_USER
  - DOCKER_PASS
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY


#### Testes
A Branch precisa ser a principal.
Instala as dependências da aplicação em uma maquina ubuntu com nodejs, e testa algumas funcionalidades da aplicação.

```
test:
  runs-on: ubuntu-latest
  if: github.ref == 'refs/heads/main'
  strategy:
    matrix:
      node-version: [14.x]
  steps:
    - uses: actions/checkout@v2
    - name: setup node
      uses: actions/setup-node@master
      with:
        node-version: ${{ matrix.node-version }}
    - name: Install dependencies
      run: |
        npm install
        npm ci
    - name: test
      run: |
        npm run test *.spec.js
```

#### Construção
Caso passe nos testes, segue para o processo de construção da imagem da aplicação e faz o  envio para o DockerHub.

```
push_to_Docker_Hub:
  runs-on: ubuntu-latest
  needs: [test]

  steps:
    - name: checkout repo
      uses: actions/checkout@v2

    - name: Set up QEMU
      uses: docker/setup-qemu-action@v1

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v1

    - name: Login to DockerHub
      uses: docker/login-action@v1
      with:
        username: ${{ secrets.DOCKER_USER }}
        password: ${{ secrets.DOCKER_PASS }}
    - name: Build and push
      uses: docker/build-push-action@v2
      with:
        context: ./
        file: ./Dockerfile
        push: true
        tags: ${{ secrets.DOCKER_USER }}/projects:ezops-test-mateuswelter-github
```


#### Implementação
Juntamente com o CodeDeploy da AWS, faz o Deploy do código para o host em que o código está hospedado, faz o pull da imagem mais recente da aplicação no DockerHub e atualiza com container.

```
deploy:
runs-on: ubuntu-latest
needs: [push_to_Docker_Hub]
steps:
  - name: Configure AWS credentials
    uses: aws-actions/configure-aws-credentials@v1
    with:
      aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
      aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      aws-region: sa-east-1
  - name: Create CodeDeploy Deployment
    id: deploy
    run: |
      aws deploy create-deployment \
        --application-name Git_application \
        --deployment-group-name dev_group \
        --deployment-config-name CodeDeployDefault.OneAtATime \
        --github-location repository=${{ github.repository }},commitId=${{ github.sha }}
```
