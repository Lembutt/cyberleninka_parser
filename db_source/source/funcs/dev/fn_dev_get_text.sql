drop function test.fn_dev_get_text;
create or replace function test.fn_dev_get_text(text_name text, query_id integer) returns json
    language plpgsql
as
$$
DECLARE
        return_row record;
        return_json json;
        query_id_exists bool;
        queries json;
    BEGIN
        EXECUTE
            'select * from test.texts where name=$1;'
        INTO return_row
        USING text_name;
        return_json = row_to_json(return_row);

        SELECT EXISTS(
            SELECT * FROM json_array_elements_text(
                return_json->'query_id'
            ) WHERE value = query_id::text
        )
        INTO query_id_exists;

        IF query_id_exists is false THEN
            EXECUTE
                'UPDATE test.texts SET query_id=query_id || $1 WHERE name=$2 RETURNING *'
            INTO return_row
            USING query_id, text_name;
            return_json = row_to_json(return_row);
        end if;
        RETURN return_json;
    end
$$;
alter function test.fn_dev_get_text(text, integer) owner to bkmanager;
------------------------------------------------------------------------------
------------------------------------------------------------------------------