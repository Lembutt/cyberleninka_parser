create table test.sources
(
    id   serial primary key,
    name text unique,
    links text unique
);

alter table test.sources
    owner to bkmanager;


-- auto-generated definition
create table test.texts
(
    id          serial primary key,
    name        text unique ,
    authors     json,
    link        text unique,
    source_id   integer,
    status      text,
    year        date,
    description text unique,
    keywords    json,
    query       json,
    annotation  text unique,
    resource    text,
    foreign key (source_id) references test.sources (id)
);

alter table test.texts
    owner to bkmanager;

---------------------------------------
drop table test.texts;
drop table test.sources;