REM Sobe um nível na estrutura de diretórios
cd ..

REM Entra no diretório 'super-heroes'
cd super-heroes

REM Executa o comando Maven Wrapper para criar um novo projeto Quarkus
mvnw.cmd io.quarkus:quarkus-maven-plugin:3.15.0:create ^

    REM Define a versão da plataforma Quarkus a ser usada
    -DplatformVersion=3.15.0 ^

    REM Define o Group ID do projeto
    -DprojectGroupId=io.quarkus.workshop.super-heroes ^

    REM Define o Artifact ID do projeto
    -DprojectArtifactId=rest-villains ^

    REM Define o nome da classe principal do recurso REST
    -DclassName="io.quarkus.workshop.superheroes.villain.VillainResource" ^

    REM Define o caminho base para o recurso REST
    -Dpath="api/villains" ^

    REM Adiciona a extensão 'rest-jackson' ao projeto para suporte a JSON
    -Dextensions="rest-jackson"