drop function test.fn_pub_add_texts;
create function test.fn_pub_add_texts(request json) returns jsonb
    language plpgsql
as
$$
DECLARE
        event text = 'fn_add_texts';
        source_id integer;
        exists bool;
        row json;
        result jsonb;
        row_was_inserted bool;
    BEGIN

        source_id = test.fn_dev_get_source_id(
            request::json ->> 'source_name'::text,
            request::json ->> 'source_link'::text,
            request::json ->> 'resource'::text
        );
        EXECUTE
            'select exists(select * from test.texts where name=$1);'
        INTO exists
        USING request::json ->> 'name';
        IF exists=true THEN
            row = test.fn_dev_get_text(request::json ->> 'name');
            row_was_inserted = false;
        ELSE
            row = test.fn_dev_insert_text(request::json, source_id);
            row_was_inserted = true;
        end if;
        result = jsonb_build_object(
            'event', event,
            'result', row,
            'was_inserted', row_was_inserted
        );
        return result;
    end
$$;
alter function test.fn_pub_add_texts(json) owner to bkmanager;

