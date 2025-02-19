# Quarkus Super Heroes

Este projeto é um exemplo de aplicação utilizando o framework Quarkus para criar uma API REST de super-heróis e vilões.

## Estrutura do Projeto

- **super-heroes**: Contém a implementação da API REST para super-heróis.
- **rest-villains**: Contém a implementação da API REST para vilões.

## Pré-requisitos

- Java 11 ou superior
- Maven 3.6.3 ou superior

## Como Executar

1. Clone o repositório:
    ```sh
    git clone <URL_DO_REPOSITORIO>
    ```

2. Navegue até o diretório do projeto:
    ```sh
    cd quarkus-super-heroes
    ```

3. Execute o comando Maven para iniciar a aplicação:
    ```sh
    ./mvnw compile quarkus:dev
    ```

## Endpoints Disponíveis

### Super-Heróis

- `GET /api/heroes`: Retorna a lista de super-heróis.
- `POST /api/heroes`: Adiciona um novo super-herói.

### Vilões

- `GET /api/villains`: Retorna a lista de vilões.
- `POST /api/villains`: Adiciona um novo vilão.

## Contribuindo

Se você deseja contribuir com este projeto, por favor, siga os passos abaixo:

1. Faça um fork do repositório.
2. Crie uma nova branch para sua feature ou correção de bug:
    ```sh
    git checkout -b minha-feature
    ```
3. Faça suas alterações e commit:
    ```sh
    git commit -m "Minha nova feature"
    ```
4. Envie suas alterações:
    ```sh
    git push origin minha-feature
    ```
5. Abra um Pull Request.

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

## Tutorial

### Criando o Primeiro Projeto

Para criar o primeiro projeto, temos scripts específicos para cada um. Esses scripts automatizam a criação dos projetos de super-heróis e vilões, configurando todas as dependências e estruturas necessárias.

#### Criando o Projeto `rest-villains`

Para criar o projeto `rest-villains`, você pode usar o script disponível em `scripts_projetos`. Siga os passos abaixo:

1. Navegue até o diretório `scripts_projetos`:
    ```sh
    cd scripts_projetos
    ```

2. Execute o script [create_rest-villans.cmd](http://_vscodecontentref_/1):
    ```sh
    create_rest-villans.cmd
    ```
3. Não deixe de analisar o script a fim de obter conhecimento sobre a criação do projeto e de como é simples utilizando quarkus.
### Rodando o Projeto `rest-villains`

Para rodar o projeto `rest-villains`, siga os passos abaixo:

1. Navegue até o diretório `rest-villains`:
    ```sh
    cd rest-villains
    ```

2. Abra um terminal e execute o comando para iniciar o projeto:
    ```sh
    mvnw.cmd quarkus:dev
    ```

O projeto estará disponível em [http://localhost:8080/api/villains](http://localhost:8080/api/villains).

Se você acessar diretamente [http://localhost:8080](http://localhost:8080), encontrará a Dev UI do Quarkus, que fornece diversas informações úteis sobre a aplicação, como os endpoints disponíveis, configurações, métricas e muito mais. A Dev UI é uma ferramenta poderosa para desenvolvedores, permitindo uma visão detalhada e interativa do estado da aplicação durante o desenvolvimento.
