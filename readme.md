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

### Adicionando Extensões de Banco de Dados e ORM

Para adicionar extensões de banco de dados e ORM ao projeto `rest-villains`, siga os passos abaixo:

1. Navegue até o diretório `rest-villains` (se ainda não estiver lá):
    ```sh
    cd rest-villains
    ```

2. Execute o comando Maven para adicionar as extensões:
    ```sh
    ./mvnw quarkus:add-extension -Dextensions="jdbc-postgresql,hibernate-orm-panache,hibernate-validator"
    ```

Essas extensões adicionam suporte para PostgreSQL, Hibernate ORM com Panache e validação de Hibernate ao projeto.

### Adicionando a Entidade `Villain`

Para adicionar a entidade `Villain` ao projeto `rest-villains`, siga os passos abaixo:

1. Crie um novo arquivo Java no diretório `src/main/java/io/quarkus/workshop/superheroes/villain` com o nome `Villain.java`.

2. Adicione o seguinte código ao arquivo `Villain.java`:

```java
package io.quarkus.workshop.superheroes.villain;

import io.quarkus.hibernate.orm.panache.PanacheEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Entity
public class Villain extends PanacheEntity {

    @NotNull
    @Size(min = 3, max = 50)
    public String name;

    public String otherName;

    @NotNull
    @Min(1)
    public int level;

    public String picture;

    @Column(columnDefinition = "TEXT")
    public String powers;

    @Override
    public String toString() {
        return "Villain{" +
            "id=" + id +
            ", name='" + name + '\'' +
            ", otherName='" + otherName + '\'' +
            ", level=" + level +
            ", picture='" + picture + '\'' +
            ", powers='" + powers + '\'' +
            '}';
    }
}
```
### Adicionando o Método findRandom()
Para adicionar o método `findRandom()` à entidade `Villain`, siga os passos abaixo:

Abra o arquivo `Villain.java` no diretório `src/main/java/io/quarkus/workshop/superheroes/villain`.

Adicione o seguinte método à classe `Villain`:
```java
public static Villain findRandom() {
    long countVillains = count();
    Random random = new Random();
    int randomVillain = random.nextInt((int) countVillains);
    return findAll().page(randomVillain, 1).firstResult();
}
```
Este método é responsável por retornar um vilão aleatório da base de dados. Ele conta o número total de vilões, gera um número aleatório dentro desse intervalo e retorna o vilão correspondente.

### Configurações iniciais o Banco de Dados

Para configurar o banco de dados para o projeto `rest-villains`, siga os passos abaixo:

1. Abra o arquivo `application.properties` no diretório `src/main/resources`.

2. Adicione as seguintes configurações ao arquivo `application.properties`:

```properties
# drop and create the database at startup (use `update` to only update the schema)
quarkus.hibernate-orm.database.generation=drop-and-create
```

### Adicionando a Classe de Serviço `VillainService`

Para adicionar a classe de serviço `VillainService` ao projeto `rest-villains`, siga os passos abaixo:

1. Crie um novo arquivo Java no diretório `src/main/java/io/quarkus/workshop/superheroes/villain` com o nome `VillainService.java`.

2. Adicione o seguinte código ao arquivo `VillainService.java`:

```java
package io.quarkus.workshop.superheroes.villain;

import static jakarta.transaction.Transactional.TxType.REQUIRED;
import static jakarta.transaction.Transactional.TxType.SUPPORTS;

import java.util.List;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;

@ApplicationScoped
@Transactional(REQUIRED)
public class VillainService {

    @Transactional(SUPPORTS)
    public List<Villain> findAllVillains() {
        return Villain.listAll();
    }

    @Transactional(SUPPORTS)
    public Villain findVillainById(Long id) {
        return Villain.findById(id);
    }

    @Transactional(SUPPORTS)
    public Villain findRandomVillain() {
        Villain randomVillain = null;
        while (randomVillain == null) {
            randomVillain = Villain.findRandom();
        }
        return randomVillain;
    }

    public Villain persistVillain(@Valid Villain villain) {
        villain.persist();
        return villain;
    }

    public Villain updateVillain(@Valid Villain villain) {
        Villain entity = Villain.findById(villain.id);
        entity.name = villain.name;
        entity.otherName = villain.otherName;
        entity.level = villain.level;
        entity.picture = villain.picture;
        entity.powers = villain.powers;
        return entity;
    }

    public void deleteVillain(Long id) {
        Villain.deleteById(id);
    }
}
```