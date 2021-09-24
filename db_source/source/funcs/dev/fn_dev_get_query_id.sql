drop function test.fn_dev_get_query_id;
create or replace function test.fn_dev_get_query_id(query_text jsonb) returns integer
    language plpgsql
as
$$
DECLARE
        query_exists    bool;
        query_id        integer;
    BEGIN
        EXECUTE
            'SELECT EXISTS(SELECT * FROM test.queries WHERE query=$1);'
        INTO query_exists
        USING query_text::jsonb;

        RAISE WARNING 'EX: %',  query_exists;
        IF query_exists is false THEN
            EXECUTE
                'INSERT INTO test.queries(query) VALUES ($1) RETURNING id;'
            INTO query_id
            USING query_text;
        ELSE
            EXECUTE
                'SELECT id FROM test.queries WHERE query=$1'
            INTO query_id
            USING query_text;
        end if;
        RAISE WARNING 'Q_ID: %',  query_id;
        RETURN query_id;

    END
$$;
alter function test.fn_dev_get_source_id(text, text, text) owner to bkmanager;
------------------------------------------------------------------------------
------------------------------------------------------------------------------