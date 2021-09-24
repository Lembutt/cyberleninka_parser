drop function test.fn_pub_add_texts;
create or replace function test.fn_pub_add_texts(request jsonb) returns jsonb
    language plpgsql
as
$$
DECLARE
        event text = 'fn_add_texts';
        source_id integer;
        text_row json;
        fn_result jsonb;
        query_id integer;
        query_data jsonb;

        -- boolean --
        text_exists bool;
        row_was_inserted bool;
    BEGIN

        source_id = test.fn_dev_get_source_id(
            request::jsonb ->> 'source_name'::text,
            request::jsonb ->> 'source_link'::text,
            request::jsonb ->> 'resource'::text
        );
        query_id = test.fn_dev_get_query_id(
            request::jsonb -> 'query'
        );
        RAISE WARNING 'Q_ID pub: %', query_id;
        -- check if te publication is in db

        EXECUTE
            'select exists(select * from test.texts where name=$1);'
        INTO text_exists
        USING request::jsonb ->> 'name';

        IF text_exists=true THEN
            text_row = test.fn_dev_get_text(
                request::jsonb ->> 'name',
                query_id::integer
            );
            row_was_inserted = false;

        ELSE
            text_row = test.fn_dev_insert_text(
                request::jsonb,
                source_id::integer,
                query_id::integer
            );
            row_was_inserted = true;
        end if;
        RAISE WARNING 'Q_ID BEFORE UPDATE: %', query_id;
        RAISE WARNING '%', text_row::json->'id';
        query_data = test.fn_dev_update_query(
            query_id,
            to_number(text_row::json->>'id', '9999999999999999999')::integer
        );

        fn_result = jsonb_build_object(
            'event', event,
            'result', text_row,
            'was_inserted', row_was_inserted,
            'query', query_data
        );
        return fn_result;
    end
$$;
alter function test.fn_pub_add_texts(jsonb) owner to bkmanager;

