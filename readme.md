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

### Configurando o Banco de Dados no Modo de Produção

No modo de produção, os serviços de desenvolvimento não serão usados. Precisamos configurar o aplicativo para conectar-se a um banco de dados real. A principal maneira de obter conexões com um banco de dados é usar uma fonte de dados. No Quarkus, a implementação pronta para uso de fonte de dados e pool de conexões é o Agroal.

Para configurar o acesso ao banco de dados no modo de produção, siga os passos abaixo:

1. Abra o arquivo `application.properties` no diretório `src/main/resources`.

2. Adicione as seguintes configurações ao arquivo `application.properties` para o modo de produção:

```properties
# Configurações do banco de dados PostgreSQL para o modo de produção
%prod.quarkus.datasource.username=superbad
%prod.quarkus.datasource.password=superbad
%prod.quarkus.datasource.jdbc.url=jdbc:postgresql://localhost:5432/villains_database
%prod.quarkus.hibernate-orm.sql-load-script=import.sql
```
`%prod`indica que a propriedade é usada somente quando o aplicativo é executado com o perfil fornecido. Configuramos o acesso ao banco de dados e forçamos a inicialização dos dados (que teria sido desabilitada por padrão no modo prod )

### Executando a infraestrutura
Antes de prosseguir, certifique-se de executar a infraestrutura. Para executar este serviço, você precisa de um banco de dados. Vamos usar o Docker e o docker compose para facilitar a instalação dessa infraestrutura.

Você já deve ter instalado a infraestrutura no diretório `infrastructure`.

Agora, basta executar `docker compose -f docker-compose.yaml up -d` ou `podman compose -f docker-compose.yaml up -d` no diretório `infrastructure`. Você deve ver alguns logs acontecendo e então todos os contêineres são iniciados.

Durante o workshop, deixe todos os contêineres funcionando. Então, depois do workshop, lembre-se de desligá-los usando: `docker compose -f docker-compose.yaml down` ou `podman compose -f docker-compose.yaml down`.

### Empacotando e executando o aplicativo
Pare o modo dev e execute: `./mvnw package`.

O aplicativo empacotado estara em `target/quarkus-app`, execute-o usando: `java -jar target/quarkus-app/quarkus-run.jar`.

Abra seu navegador em http://localhost:8080/api/villains e verifique se ele exibe o conteúdo esperado. Uma vez feito isso, pare o aplicativo usando `CTRL+C`

### Modificando a Porta Padrão de Villains para 8084

Para evitar conflitos com outros microserviços, vamos modificar a porta padrão para 8084. Siga os passos abaixo:

1. Abra o arquivo `application.properties` no diretório `src/main/resources`.

2. Adicione a seguinte configuração ao arquivo `application.properties`:

```properties
## HTTP configuration
quarkus.http.port=8084
```

### Propriedade `level.multiplier`

A propriedade `level.multiplier` é usada na classe `VillainService` para ajustar o nível dos vilões. Será utilizada no método `persistVillain`. 

```java
import org.eclipse.microprofile.config.inject.ConfigProperty;

//...
@ConfigProperty(name = "level.multiplier", defaultValue="1.0")
double levelMultiplier;
//...
public Villain persistVillain(@Valid Villain villain) {
    villain.level = (int) (villain.level * levelMultiplier);
    villain.persist();
    return villain;
}
```
Ela pode ser configurada via variável de ambiente ou no arquivo `application.properties`.

#### Configurando via `application.properties`

1. Abra o arquivo `application.properties` no diretório `src/main/resources`.

2. Adicione a seguinte configuração ao arquivo `application.properties`:

```properties
## Configuration for the REST API
level.multiplier=0.5
```

### Testando a Propriedade `level.multiplier`

Para testar a nova propriedade `level.multiplier`, siga os passos abaixo:

1. Certifique-se de que a aplicação está em execução na porta 8084.

2. Utilize o seguinte JSON para criar um novo vilão:

```json
{
  "level": 5,
  "name": "Super Bad",
  "powers": "Agility, Longevity"
}
```
3. Faça uma requisição `POST` para http://localhost:8084/api/villains, passando o json no body da request. 

4. Vai receber `201 Created` e o header `location` tera o link para consulta deste novo recurso inserido exemplo `http://localhost:8084/api/villains/582`.

5. Observe que o nível do vilão será reduzido de acordo com o valor configurado para `level.multiplier`. Por exemplo, se `level.multiplier` estiver configurado como `0.5`, o nível do vilão será `2.5` (arredondado para 2)

```json
{
  "id": 582,
  "name": "Super Bad",
  "otherName": null,
  "level": 2,
  "picture": null,
  "powers": "Agility, Longevity"
}
```

Esta configuração garante que o nível dos vilões seja ajustado de acordo com o multiplicador definido, evitando que o código quebre caso a propriedade não seja informada no arquivo `application.properties` ou via variável de ambiente.

