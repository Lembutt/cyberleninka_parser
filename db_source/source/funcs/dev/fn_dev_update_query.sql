create or replace function test.fn_dev_update_query(query_id integer, text_id integer) returns jsonb
    language plpgsql
as
$$
DECLARE
        query_result test.queries.result%TYPE;
        query_text test.queries.query%TYPE;
        return_data jsonb;
    BEGIN
        EXECUTE
            'SELECT result ' ||
            'FROM test.queries ' ||
            'WHERE id=$1;'
        INTO query_result
        USING query_id;

        IF ARRAY [query_result] @> ARRAY[text_id] is false THEN
            EXECUTE
                'UPDATE test.queries ' ||
                'SET result = array_append($1, $2) ' ||
                'WHERE id=$3 ' ||
                'RETURNING query, result;'
            USING query_result, text_id, query_id
            INTO query_text, query_result;
        end if;
        return_data = jsonb_build_object(
            'id', query_id,
            'query', query_text,
            'result', query_result
        );
        return return_data;
    END
$$;

alter function test.fn_dev_update_query(integer, integer) owner to bkmanager;