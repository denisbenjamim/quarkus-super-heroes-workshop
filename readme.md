# Quarkus Super Heroes

Este projeto é um exemplo de aplicação utilizando o framework Quarkus para criar uma API REST de super-heróis e vilões.

## Estrutura do Projeto

- **super-heroes**: Contém a implementação da API REST para super-heróis.
- **rest-villains**: Contém a implementação da API REST para vilões.

## Pré-requisitos

- Java 11 ou superior
- Maven 3.6.3 ou superior

## Como Executar

1. baixe o arquivo aqui `https://raw.githubusercontent.com/quarkusio/quarkus-workshops/refs/heads/main/quarkus-workshop-super-heroes/dist/quarkus-super-heroes-workshop.zip` e descompacte.

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
### Iniciando a Aplicação no Modo Dev

Agora vamos iniciar a aplicação no modo dev. Desde que tenhamos Docker ou Podman instalados e configurados, o Quarkus irá fazer isso para nós. Sim, isso mesmo, não precisamos nos preocupar com detalhes como instalar ou configurar o banco de dados.

Para iniciar a aplicação no modo dev, siga os passos abaixo:

1. Navegue até o diretório `rest-villains` (se ainda não estiver lá):
    ```sh
    cd rest-villains
    ```

2. Abra um terminal e execute o comando para iniciar o projeto:
    ```sh
    ./mvnw quarkus:dev
    ```

O Quarkus irá automaticamente configurar e iniciar um contêiner Docker ou Podman com o banco de dados necessário para a aplicação. O projeto estará disponível em [http://localhost:8080/api/villains](http://localhost:8080/api/villains).

Se você acessar diretamente [http://localhost:8080](http://localhost:8080), encontrará a Dev UI do Quarkus, que fornece diversas informações úteis sobre a aplicação, como os endpoints disponíveis, configurações, métricas e muito mais. A Dev UI é uma ferramenta poderosa para desenvolvedores, permitindo uma visão detalhada e interativa do estado da aplicação durante o desenvolvimento.

### Desabilitando o Testcontainers Ryuk

Caso ocorra um problema no console referente ao Testcontainers Ryuk, você pode desabilitá-lo usando a seguinte variável de ambiente:

1. Abra o arquivo [application.properties](http://_vscodecontentref_/1) no diretório `src/main/resources`.

2. Adicione a seguinte configuração ao arquivo [application.properties](http://_vscodecontentref_/2):

```properties
quarkus.test.containers.env-vars.TESTCONTAINERS_RYUK_DISABLED=true
```
### Adicionando os Métodos à Classe `VillainResource`

Para adicionar os novos métodos à classe `VillainResource`, siga os passos abaixo:

1. Abra o arquivo `VillainResource.java` no diretório `src/main/java/io/quarkus/workshop/superheroes/villain`.

2. subtitua seu conteudo conforme os seguintes métodos e construtor da classe `VillainResource`:

```java
Logger logger;
VillainService service;

public VillainResource(Logger logger, VillainService service) {
    this.service = service;
    this.logger = logger;
}

@GET
@Path("/random")
public RestResponse<Villain> getRandomVillain() {
    Villain villain = service.findRandomVillain();
    logger.debug("Found random villain " + villain);
    return RestResponse.ok(villain);
}

@GET
public RestResponse<List<Villain>> getAllVillains() {
    List<Villain> villains = service.findAllVillains();
    logger.debug("Total number of villains " + villains.size());
    return RestResponse.ok(villains);
}

@GET
@Path("/{id}")
public RestResponse<Villain> getVillain(@RestPath Long id) {
    Villain villain = service.findVillainById(id);
    if (villain != null) {
        logger.debug("Found villain " + villain);
        return RestResponse.ok(villain);
    } else {
        logger.debug("No villain found with id " + id);
        return RestResponse.noContent();
    }
}

@POST
public RestResponse<Void> createVillain(@Valid Villain villain, @Context UriInfo uriInfo) {
    villain = service.persistVillain(villain);
    UriBuilder builder = uriInfo.getAbsolutePathBuilder().path(Long.toString(villain.id));
    logger.debug("New villain created with URI " + builder.build().toString());
    return RestResponse.created(builder.build());
}

@PUT
public RestResponse<Villain> updateVillain(@Valid Villain villain) {
    villain = service.updateVillain(villain);
    logger.debug("Villain updated with new values " + villain);
    return RestResponse.ok(villain);
}

@DELETE
@Path("/{id}")
public RestResponse<Void> deleteVillain(@RestPath Long id) {
    service.deleteVillain(id);
    logger.debug("Villain deleted with id " + id);
    return RestResponse.noContent();
}

@GET
@Path("/hello")
@Produces(TEXT_PLAIN)
public String hello() {
    return "Hello Villain Resource";
}
```

### Adicionando Dados Iniciais

Para adicionar dados iniciais ao projeto `rest-villains`, siga os passos abaixo:

1. Crie um novo arquivo SQL no diretório `src/main/resources` com o nome `import.sql`.

2. Adicione o seguinte conteúdo ao arquivo `import.sql` baixe a versão completa aqui `https://raw.githubusercontent.com/quarkusio/quarkus-workshops/refs/heads/main/quarkus-workshop-super-heroes/super-heroes/rest-villains/src/main/resources/import.sql`:

```sql
ALTER SEQUENCE villain_seq RESTART WITH 50;

INSERT INTO villain(id, name, otherName, picture, powers, level)
VALUES (nextval('villain_seq'), 'Buuccolo', 'Majin Buu',
        'https://www.superherodb.com/pictures2/portraits/10/050/15355.jpg',
        'Accelerated Healing, Adaptation, Agility, Flight, Immortality, Intelligence, Invulnerability, Reflexes, Self-Sustenance, Size Changing, Spatial Awareness, Stamina, Stealth, Super Breath, Super Speed, Super Strength, Teleportation',
        22);
INSERT INTO villain(id, name, otherName, picture, powers, level)
VALUES (nextval('villain_seq'), 'Darth Vader', 'Anakin Skywalker',
        'https://www.superherodb.com/pictures2/portraits/10/050/10444.jpg',
        'Accelerated Healing, Agility, Astral Projection, Cloaking, Danger Sense, Durability, Electrokinesis, Energy Blasts, Enhanced Hearing, Enhanced Senses, Force Fields, Hypnokinesis, Illusions, Intelligence, Jump, Light Control, Marksmanship, Precognition, Psionic Powers, Reflexes, Stealth, Super Speed, Telekinesis, Telepathy, The Force, Weapons Master',
        13);
INSERT INTO villain(id, name, otherName, picture, powers, level)
VALUES (nextval('villain_seq'), 'The Rival (CW)', 'Edward Clariss',
        'https://www.superherodb.com/pictures2/portraits/10/050/13846.jpg',
        'Accelerated Healing, Agility, Bullet Time, Durability, Electrokinesis, Endurance, Enhanced Senses, Intangibility, Marksmanship, Phasing, Reflexes, Speed Force, Stamina, Super Speed, Super Strength',
        10);
```
1. Agora inicie a aplicação 
 ```sh
    ./mvnw compile quarkus:dev
```
2. Então, abra seu navegador em `http://localhost:8080/api/villains`. Você deve ver muitos vilões…

### Adicionando Métodos de Teste à Classe `VillainResourceTest`

Para adicionar novos métodos de teste à classe `VillainResourceTest`, siga os passos abaixo:

1. Abra o arquivo `VillainResourceTest.java` no diretório `src/test/java/io/quarkus/workshop/superheroes/villain`.

2. Adicione os seguintes métodos à classe `VillainResourceTest`:

```java
@Test
void shouldGetRandomVillain() {
    given().when().get("/api/villains/random").then().statusCode(OK.getStatusCode()).contentType(APPLICATION_JSON);
}

@Test
void shouldNotGetUnknownVillain() {
    Long randomId = new Random().nextLong();
    given().pathParam("id", randomId).when().get("/api/villains/{id}").then().statusCode(NO_CONTENT.getStatusCode());
}

@Test
void shouldNotAddInvalidItem() {
    Villain villain = new Villain();
    villain.name = null;
    villain.otherName = DEFAULT_OTHER_NAME;
    villain.picture = DEFAULT_PICTURE;
    villain.powers = DEFAULT_POWERS;
    villain.level = 0;

    given()
        .body(villain)
        .header(CONTENT_TYPE, JSON)
        .header(ACCEPT, JSON)
        .when()
        .post("/api/villains")
        .then()
        .statusCode(BAD_REQUEST.getStatusCode());
}

@Test
@Order(1)
void shouldGetInitialItems() {
    List<Villain> villains = get("/api/villains")
        .then()
        .statusCode(OK.getStatusCode())
        .contentType(APPLICATION_JSON)
        .extract()
        .body()
        .as(getVillainTypeRef());
    assertEquals(NB_VILLAINS, villains.size());
}

@Test
@Order(2)
void shouldAddAnItem() {
    Villain villain = new Villain();
    villain.name = DEFAULT_NAME;
    villain.otherName = DEFAULT_OTHER_NAME;
    villain.picture = DEFAULT_PICTURE;
    villain.powers = DEFAULT_POWERS;
    villain.level = DEFAULT_LEVEL;

    String location = given()
        .body(villain)
        .header(CONTENT_TYPE, JSON)
        .header(ACCEPT, JSON)
        .when()
        .post("/api/villains")
        .then()
        .statusCode(CREATED.getStatusCode())
        .extract()
        .header("Location");
    assertTrue(location.contains("/api/villains"));

    // Stores the id
    String[] segments = location.split("/");
    villainId = segments[segments.length - 1];
    assertNotNull(villainId);

    given()
        .pathParam("id", villainId)
        .when()
        .get("/api/villains/{id}")
        .then()
        .statusCode(OK.getStatusCode())
        .contentType(APPLICATION_JSON)
        .body("name", Is.is(DEFAULT_NAME))
        .body("otherName", Is.is(DEFAULT_OTHER_NAME))
        .body("level", Is.is(DEFAULT_LEVEL))
        .body("picture", Is.is(DEFAULT_PICTURE))
        .body("powers", Is.is(DEFAULT_POWERS));

    List<Villain> villains = get("/api/villains")
        .then()
        .statusCode(OK.getStatusCode())
        .contentType(APPLICATION_JSON)
        .extract()
        .body()
        .as(getVillainTypeRef());
    assertEquals(NB_VILLAINS + 1, villains.size());
}

@Test
@Order(3)
void testUpdatingAnItem() {
    Villain villain = new Villain();
    villain.id = Long.valueOf(villainId);
    villain.name = UPDATED_NAME;
    villain.otherName = UPDATED_OTHER_NAME;
    villain.picture = UPDATED_PICTURE;
    villain.powers = UPDATED_POWERS;
    villain.level = UPDATED_LEVEL;

    given()
        .body(villain)
        .header(CONTENT_TYPE, JSON)
        .header(ACCEPT, JSON)
        .when()
        .put("/api/villains")
        .then()
        .statusCode(OK.getStatusCode())
        .contentType(APPLICATION_JSON)
        .body("name", Is.is(UPDATED_NAME))
        .body("otherName", Is.is(UPDATED_OTHER_NAME))
        .body("level", Is.is(UPDATED_LEVEL))
        .body("picture", Is.is(UPDATED_PICTURE))
        .body("powers", Is.is(UPDATED_POWERS));

    List<Villain> villains = get("/api/villains")
        .then()
        .statusCode(OK.getStatusCode())
        .contentType(APPLICATION_JSON)
        .extract()
        .body()
        .as(getVillainTypeRef());
    assertEquals(NB_VILLAINS + 1, villains.size());
}

@Test
@Order(4)
void shouldRemoveAnItem() {
    given().pathParam("id", villainId).when().delete("/api/villains/{id}").then().statusCode(NO_CONTENT.getStatusCode());

    List<Villain> villains = get("/api/villains")
        .then()
        .statusCode(OK.getStatusCode())
        .contentType(APPLICATION_JSON)
        .extract()
        .body()
        .as(getVillainTypeRef());
    assertEquals(NB_VILLAINS, villains.size());
}

private TypeRef<List<Villain>> getVillainTypeRef() {
    return new TypeRef<List<Villain>>() {
        // Kept empty on purpose
    };
}
```
Agora execute os testes no modo dev `./mvnw test` eles devem passar