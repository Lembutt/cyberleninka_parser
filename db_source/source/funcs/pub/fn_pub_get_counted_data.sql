create or replace function test.fn_pub_get_counted_data(request jsonb) returns jsonb
    language plpgsql
as
$$
DECLARE
        event text = 'fn_get_keywords';
        procedure_rows record;
        r record;
        r_json json;
        fn_result jsonb;
        fn_authors_result jsonb = '{}'::jsonb;
        fn_keywords_result jsonb = '{}'::jsonb;
        fn_annotations_result jsonb = '[]'::jsonb;
        author text;
        keyword text;
        annotation_ text;
        counter integer;


    BEGIN
        IF request::jsonb->>'get'='true' THEN
            FOR r IN
                SELECT annotation
                FROM test.texts
                WHERE status!='[]'
                LIMIT 500
            LOOP
                r_json = row_to_json(r);
                fn_annotations_result = fn_annotations_result::jsonb || jsonb_build_array(r)::jsonb;
            end loop;
        fn_result = jsonb_build_object(
            'event', event,
            'query', request,
            'annotations', fn_annotations_result
        );
        return fn_result;
        end if;
    end
$$;