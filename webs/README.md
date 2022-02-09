# Web PALCO. Proyecto WordPress.

## Ramas
La rama master se usa como rama de liberación, por lo que cada proyecto se crea con este README.md en la rama master y el primer commit se realiza a la rama llamada **develop** donde se mezclarán regularmente las n ramas que existan.


## Archivos que deben subir con el primer push

- .gitignore
- exclude-list.txt
- .gitlab-cloud-ci.yml

### Gitignore para WordPress
Los proyectos de Wordpress deben contar con el archivo **.gitignore** y con el siguiente contenido inicialmente. Siéntase libre de añadir lo que crea conveniente.

```
*.log
wp-config.php
wp-content/advanced-cache.php
wp-content/backup-db/
wp-content/backups/
wp-content/blogs.dir/
wp-content/cache/
wp-content/upgrade/
wp-content/wp-cache-config.php
license.txt
.gitlab-ci.yml
readme.html
sitemap.xml
sitemap.xml.gz
.idea/
*.ipr
*.iws
.idea_modules/
.htaccess
```

### Lista de exclusion

Para desplegar las web a produccion se usa el comando ```rsync``` y para evitar que se copien en el server archivos 
innecesarios se debe incluir en el proyecto el archivo exclude-list.txt con el siguiente contenido.

```
.gitlab-cloud-ci.yml
*.sql
.gitignore
.idea/
.git/
```
Tenga en cuenta que la actualizacion de la base de datos se maneja con la variable *DEPLOY_DB*. 

### GitLab pipeline

Antes de pushear la primera vez al repositorio debe añadir un archivo llamado .gitlab-cloud-ci.yml con el siguiente contenido.
Donde va a sustituir el nombre del proyecto en las variables *PROJECT*, *URL* y en la linea "file: 'cloud_webs_ci/gitlab-proyecto.yml'"

El valor por defecto de la varible *DEPLOY_DB* es true pra que la primera vez que pushee se actualice la base de datos,
si mas adelante no desea que se actualice la base de datos debe cambiar el valor de la variable a _false_.

```
variables:
  PROJECT: "proyecto"
  PREFIX: 'wp'
  AUTO_DAST_JOB: "false"
  URL: 'http://proyecto.companyxyz.com'
  DEPLOY_DB: "true"

include:
  - project: 'devops/templates'
    file: 'cloud_webs_ci/gitlab-webs.yml'
```

## Requisitos de los proyectos

- Deshabilitar gravatar en los perfiles de usuarios
- Deshabilitar las actualizaciones automaticas de WordPress

## Archivo .sql
El nombre del archivo .sql que se sube debe cumplir el siguiente convenio.
`<prefijo>_<nombre_del_proyecto>.sql`
El prefijo generalmente es un código de tres letras que identifica al proyecto y el nombre el proyecto se debe resumir en una palabra.  Este convenio se utiliza para extraer del nombre del archivo la información necesaria para crear y modificar la base de datos en los servidores de testing y stagin en el pipline de CI/CD.

Ejemplo:

**ejm_editorialjm.sql**

Prefijo de las tablas de WordPress:     ejm_

Nombre de la db en el server testing:   ejm_editorialjm
