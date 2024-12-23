# README.md

## Desafio DevOps - Configuração de Deployment e Service no Kubernetes

### Objetivo
Este projeto define e implementa uma aplicação containerizada no Kubernetes utilizando os manifestos `deployment.yaml` e `service.yaml`. A seguir, detalhamos cada aspecto de sua configuração e propósito.

---

### Arquivo: `deployment.yaml`

#### Descrição
O arquivo `deployment.yaml` é responsável por definir um recurso do tipo `Deployment`, que gerencia a implantação e o ciclo de vida dos pods associados à aplicação.

#### Estrutura e Configurações

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: desafio-devops-api
```
- **apiVersion**: Versão da API do Kubernetes utilizada para definir o `Deployment`.
- **kind**: Tipo do recurso, neste caso, um `Deployment`.
- **metadata.name**: Nome único do recurso dentro do namespace, aqui identificado como `desafio-devops-api`.

```yaml
spec:
  selector:
    matchLabels:
      app: desafio-devops-api
```
- **spec.selector.matchLabels**: Critério usado pelo Deployment para identificar os pods que ele gerencia. A label `app: desafio-devops-api` deve estar presente nos pods definidos no template.

```yaml
  template:
    metadata:
      labels:
        app: desafio-devops-api
```
- **template.metadata.labels**: Rótulos atribuídos ao pod para permitir o mapeamento pelo `selector` do Deployment e por outros objetos, como Services.

```yaml
    spec:
      containers:
      - name: desafio-devops-api
        image: docker.io/library/desafio-devops-api:kind-v1
        imagePullPolicy: Never
```
- **containers.name**: Nome do container.
- **containers.image**: Imagem Docker utilizada para o container. Neste exemplo, `docker.io/library/desafio-devops-api:kind-v1`.
- **containers.imagePullPolicy**: Define como a imagem será obtida. `Never` indica que a imagem será utilizada localmente e não será baixada do registro Docker.

```yaml
        env:
        - name: NAME
          value: "Vinicius"
```
- **env**: Variável de ambiente disponível no container. Aqui, define a variável `NAME` com o valor "Vinicius".

```yaml
        resources:
          limits:
            cpu: "0.5"
            memory: "100Mi"
          requests:
            cpu: "0.5"
            memory: "50Mi"
```
- **resources.limits**: Define os limites máximos de recursos (CPU e memória) disponíveis para o container.
- **resources.requests**: Define os recursos mínimos garantidos para o container.

```yaml
        ports:
        - containerPort: 3000
```
- **ports.containerPort**: Porta exposta pelo container dentro do pod.

```yaml
        readinessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 10
```
- **readinessProbe**: Verifica se o container está pronto para receber tráfego. Utiliza a porta TCP 8080, aguarda 15 segundos antes da primeira verificação e realiza checagens a cada 10 segundos.

```yaml
        livenessProbe:
          tcpSocket:
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 10
```
- **livenessProbe**: Verifica se o container está em funcionamento. Configuração semelhante à `readinessProbe`, utilizando a porta TCP 8080.

---

### Arquivo: `service.yaml`

#### Descrição
O arquivo `service.yaml` define um recurso do tipo `Service`, que expõe os pods gerenciados pelo Deployment, permitindo o acesso interno e externo à aplicação.

#### Estrutura e Configurações

```yaml
apiVersion: v1
kind: Service
metadata:
  name: desafio-devops-service
```
- **apiVersion**: Versão da API do Kubernetes utilizada para definir o `Service`.
- **kind**: Tipo do recurso, neste caso, um `Service`.
- **metadata.name**: Nome único do recurso dentro do namespace, aqui identificado como `desafio-devops-service`.

```yaml
spec:
  selector:
    app: desafio-devops-api
```
- **spec.selector**: Seleciona os pods a serem expostos pelo Service com base no rótulo `app: desafio-devops-api`.

```yaml
  ports:
  - port: 3000
    targetPort:  3000
```
- **ports.port**: Porta em que o Service estará acessível.
- **ports.targetPort**: Porta do container no pod para onde o tráfego será encaminhado.

---

### Fluxo da Aplicação
1. **Deployment**:
   - Garante que a aplicação `desafio-devops-api` esteja rodando em um ou mais pods.
   - Configura o ambiente do container, gerencia os recursos e expõe a porta 3000.

2. **Probes**:
   - **Readiness Probe**: Garante que o container esteja pronto para receber tráfego antes de redirecionar requisições.
   - **Liveness Probe**: Monitora a saúde do container e reinicia-o caso detecte falhas.

3. **Service**:
   - Exponibiliza o acesso ao Deployment utilizando a mesma porta 3000.
   - Redireciona as requisições para os pods selecionados pelo rótulo `app: desafio-devops-api`.

---

### Como Aplicar os Manifestos
1. Verifique a conexão com o cluster Kubernetes.
2. Aplique os arquivos de manifesto:
   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   ```
3. Verifique os recursos criados:
   ```bash
   kubectl get deployments
   kubectl get pods
   kubectl get services
   ```

---

### Resultado Esperado
- Um Deployment gerencia os pods da aplicação `desafio-devops-api`.
- Um Service expõe os pods, permitindo o acesso à aplicação na porta 3000.
- As Probes garantem a saúde e disponibilidade do container.

---

### Observações
- Certifique-se de que a imagem Docker `desafio-devops-api:kind-v1` esteja disponível localmente ao usar a política `imagePullPolicy: Never`.
- Ajuste os valores de `resources` conforme a capacidade do cluster.