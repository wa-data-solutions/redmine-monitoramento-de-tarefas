SELECT
    v.id                           AS id_versao,
    v.name                         AS nome_versao,
    cv.value                       AS versao_baseline_origem,
    v.effective_date               AS data_planejamento_versao,   
    p.id                           AS id_projeto,
    p.name                         AS nome_projeto,
    i.id                           AS id_tarefa,
    i.subject                      AS tarefa_relacionada
    i.status_id                    AS status_tarefa,
    i.created_on                   AS data_criacao_tarefa
FROM versions v
LEFT JOIN projects p
       ON p.id = v.project_id
LEFT JOIN custom_values cv
       ON cv.customized_id = v.id
      AND cv.customized_type = 'Version'
LEFT JOIN custom_fields cf
       ON cf.id = cv.custom_field_id
      AND cf.name = 'Versão Baseline Origem'
LEFT JOIN issues i
       ON i.fixed_version_id = v.id
WHERE cf.id IS NOT NULL
   OR cv.id IS NULL
ORDER BY
    p.name,
    v.name,
    i.id;