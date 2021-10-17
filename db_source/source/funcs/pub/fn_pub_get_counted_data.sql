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
        author text;
        keyword text;
        counter integer;


    BEGIN
        IF request::jsonb->>'get'='true' THEN
            FOR r IN
                SELECT authors, keywords
                FROM test.texts
            LOOP
                r_json = row_to_json(r);
                FOR author in
                    SELECT *
                    FROM json_array_elements(r_json::json->'authors')
                LOOP
                    IF fn_authors_result ? author THEN
                        counter = (fn_authors_result::jsonb->>author)::integer;
                        fn_authors_result = fn_authors_result::jsonb - author;
                    ELSE
                        counter = 0;
                    end if;
                    fn_authors_result = fn_authors_result || jsonb_build_object(lower(author), counter::integer + 1);
                end loop;
                FOR keyword in
                    SELECT *
                    FROM json_array_elements(r_json::json->'keywords')
                LOOP
                    IF fn_keywords_result ? keyword THEN
                        counter = (fn_keywords_result::jsonb->>keyword)::INTEGER;
                        fn_keywords_result = fn_keywords_result::jsonb - keyword;
                    ELSE
                        counter = 0;
                    end if;
                    fn_keywords_result = fn_keywords_result || jsonb_build_object(lower(keyword), counter::integer+1);

                end loop;
            end loop;
        fn_result = jsonb_build_object(
            'event', event,
            'query', request,
            'keywords', fn_keywords_result,
            'authors', fn_authors_result
        );
        return fn_result;
        end if;
    end
$$;