drop table test.texts;
drop table test.sources;
drop table test.queries;

create table test.sources
(
    id          serial primary key,
    name        text unique,
    links       text unique
);
alter table test.sources
    owner to bkmanager;

---------------------------------------

create table test.queries
(
    id          serial primary key,
    query       jsonb not null,
    result      integer[] default array[]::integer[]
);
alter table test.queries
    owner to bkmanager;

---------------------------------------

create table test.texts
(
    id          serial primary key,
    name        text unique,
    authors     jsonb,
    link        text unique,
    source_id   integer,
    status      jsonb,
    year        date,
    description text,
    keywords    jsonb,
    query_id    integer[],
    text        text,
    resource    text,
    annotation  text,
    foreign key (source_id) references test.sources (id)
);
alter table test.texts
    owner to bkmanager;



