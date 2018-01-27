--SQL query to generate a JSON archive job description to feed bulk archive update process
--  for IEDA. The JSON files generated are used by the bagit and copy to archive process
--  implemented by Neville Shane as a component of the ATP Data Submission Hub workflow.
-- Stephen M. Richard
--  2017-03-30

select s.submission_id, 



(select row_to_json(aaa) from (
    select 
  s.title as "itemName",
  translate(trim((date_trunc('second', current_timestamp(0)))::text),' ', 'T') as "jobSubmissionDate",
 -- array of identifiers, each with a 'type'; 'DOI' should be one of these, 
 -- if not some other globally unique id should be included, here the second option
 -- is a urn based on the primary key of the submissions table in the EarthChemLibrary 
 -- database
  (select array_to_json(
	array[(
		select row_to_json(xx) from
			(select 'DOI' as "identifierType",
				s.dataset_doi as identifier 
			)  xx
		) ,
		(select row_to_json(yy) from
			(select 'IEDA submission_ID' as "identifierType",
				concat('urn:grl:submission:', s.submission_ID) as identifier 
			) yy)
		]
	)) as identifiers,
-- provide format (e.g. ISO19139, DataCite v4, using the xml schema namespace URI if its xml) and
-- a  path to retrieve the metadata record documenting the repository item.
	(select row_to_json(zz) from 
		(select 'http://datacite.org/schema/kernel-4'::text as format,
			concat('metadata/',
				(case
					when (s.dataset_doi != '') then
					concat(right(trim(leading 'doi:'::text from s.dataset_doi),6),'-'::text)
					end),
				'submission-id'::text ,trim(to_char(s.submission_id,'0000')),
				'.xml'::text
			) as "metadataFileLocation" 
		)  zz
	) as "metadataLink",
-- construct array of repository content items to load into the archive object; each has a path for locating
-- the content items; this can be local file paths the processor will understand, or a URL
    (
      select array_to_json(array_agg(row_to_json(d)))
		from (
			SELECT 
				concat('%path%/submissions/in/'::text,s.submission_id,'/'::text, dfl.dataset_server_filename) "fileLocation", 
				concat(dff.data_file_format, ': ', dff.data_file_format_name) format
			from
			  dataset_file_list dfl, 
			data_file_formats dff
				where   s.submission_id = dfl.submission_id AND
				dfl.data_file_format_id = dff.data_file_format_id
			) d
		) as "contentItems",
		''::text as "archiveAccessionDate",
		''::text as "archiveID",
		'EarthChem Library'::text as "sourceSystem",
		'getFile-dcv4-tgzbagit-CUL'::text as "archiveWorkflow"

		) as aaa
	) as "archiveJob"
  FROM
  submissions s

WHERE 
-- only take published repository items, indicated by status_id=2
   s.status_id=2 ;