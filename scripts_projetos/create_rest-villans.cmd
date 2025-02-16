cd ..
cd super-heroes

mvnw.cmd io.quarkus:quarkus-maven-plugin:3.15.0:create ^
    -DplatformVersion=3.15.0 ^
    -DprojectGroupId=io.quarkus.workshop.super-heroes ^
    -DprojectArtifactId=rest-villains ^
    -DclassName="io.quarkus.workshop.superheroes.villain.VillainResource" ^
    -Dpath="api/villains" ^
    -Dextensions="rest-jackson"