CREATE DATABASE "QSR" ENCODING = 'UTF8';
CREATE DATABASE "SenseServices" ENCODING = 'UTF8';
CREATE DATABASE "QSMQ" ENCODING = 'UTF8';
CREATE DATABASE "Licenses" ENCODING = 'UTF8'; //one at a time

-- from here the whole script

CREATE ROLE "qliksenserepository" WITH LOGIN NOINHERIT NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION VALID UNTIL 'infinity'; -- change <qliksenserepository_user_pass> to your password for the repository service user
ALTER ROLE "qliksenserepository" WITH ENCRYPTED PASSWORD '<qliksenserepository_user_pass>';
GRANT qliksenserepository TO postgres;

ALTER DATABASE "QSR" OWNER TO "qliksenserepository";
ALTER DATABASE "SenseServices" OWNER TO "qliksenserepository";
ALTER DATABASE "QSMQ" OWNER TO "qliksenserepository";
ALTER DATABASE "Licenses" OWNER TO qliksenserepository;

GRANT TEMPORARY, CONNECT ON DATABASE "QSMQ" TO PUBLIC;
GRANT ALL ON DATABASE "QSMQ" TO postgres;
GRANT CREATE ON DATABASE "QSMQ" TO "qliksenserepository";
GRANT TEMPORARY, CONNECT ON DATABASE "SenseServices" TO PUBLIC;
GRANT ALL ON DATABASE "SenseServices" TO postgres;
GRANT CREATE ON DATABASE "SenseServices" TO "qliksenserepository";

GRANT TEMPORARY, CONNECT ON DATABASE "Licenses" TO PUBLIC;
GRANT ALL ON DATABASE "Licenses" TO postgres;
GRANT CREATE ON DATABASE "Licenses" TO qliksenserepository;