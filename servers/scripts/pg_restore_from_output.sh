#!/bin/bash
ssh user@1.1.1.1 "pg_dump -h localhost -U user -p 5432 dbname -w -Fc" | pg_restore -Fc -w -h localhost -p 5432 -U user --role=user -Ox -d dbname
