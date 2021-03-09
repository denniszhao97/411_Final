# 411_Final
Github for MSiA 411 Data Visualization Final Project

Published Tableau Story is at https://public.tableau.com/profile/zhonghao.zhao#!/vizhome/USGunViolenceAnalysisfrom2013-2018/Story1

## Data format

The data is stored in a single CSV file sorted by increasing date. It has the following fields:

| field                   | type         | description                                                               | required? |
|-----------------------------|------------------|-------------------------------------------------------------------------------|---------------|
| incident_id                 | int              |                 gunviolencearchive.org ID for incident                        | yes           |
| date                        | str              |                           date of occurrence                                  | yes           |
| state                       | str              |                                                                               | yes           |
| city_or_county              | str              |                                                                               | yes           |
| address                     | str              | address where incident took place                                             | yes           |
| n_killed                    | int              | number of people killed                                                       | yes           |
| n_injured                   | int              | number of people injured                                                      | yes           |
| incident_url                | str              | link to gunviolencearchive.org webpage containing details of incident         | yes           |
| source_url                  | str              | link to online news story concerning incident                                 | no            |
| incident_url_fields_missing | bool             | ignore, always False                                                          | yes           |
| congressional_district      | int              |                                                                               | no            |
| gun_stolen                  | dict[int, str] | key: gun ID, value: 'Unknown' or 'Stolen'                                     | no            |
| gun_type                    | dict[int, str] | key: gun ID, value: description of gun type                                   | no            |
| incident_characteristics    | list[str]        | list of incident characteristics                                              | no            |
| latitude                    | float            |                                                                               | no            |
| location_description        | str              | description of location where incident took place                             | no            |
| longitude                   | float            |                                                                               | no            |
| n_guns_involved             | int              | number of guns involved                                                       | no            |
| notes                       | str              | additional notes about the incident                                           | no            |
| participant_age             | dict[int, int] | key: participant ID                                                           | no            |
| participant_age_group       | dict[int, str] | key: participant ID, value: description of age group, e.g. 'Adult 18+'        | no            |
| participant_gender          | dict[int, str] | key: participant ID, value: 'Male' or 'Female'                                | no            |
| participant_name            | dict[int, str] | key: participant ID                                                           | no            |
| participant_relationship    | dict[int, str] | key: participant ID, value: relationship of participant to other participants | no            |
| participant_status          | dict[int, str] | key: participant ID, value: 'Arrested', 'Killed', 'Injured', or 'Unharmed'    | no            |
| participant_type            | dict[int, str] | key: participant ID, value: 'Victim' or 'Subject-Suspect'                     | no            |
| sources                     | list[str]        | links to online news stories concerning incident                              | no            |
| state_house_district        | int              |                                                                               | no            |
| state_senate_district       | int              |                                                                               | no            |

Important notes:

- Each list is encoded as a string with separator `||`. For example, `"a||b"` represents `['a', 'b']`.
- Each dict is encoded as a string with outer separator `||` and inner separator `::`. For example, `0::a, 1::b` represents `{0: 'a', 1: 'b'}`.
- The "gun ID" and "participant ID" are numbers specific to a given incident that refer to a particular gun/person involved in that incident. For example, this:

  ```
  participant_age_group = 0::Teen 12-17||1::Adult 18+
  participant_status = 0::Killed||1::Injured
  participant_type = 0::Victim||1::Victim
  ```

  corresponds to this:

  |                    | Age Group | Status | Type |
  |--------------------|---------------|------------|----------|
  | **Participant #0** | Teen 12-17    | Killed     | Victim   |
  | **Participant #1** | Adult 18+     | Injured    | Victim   |

### Example

The incident described [here](http://www.gunviolencearchive.org/incident/1081561) resulted in the following fields:

| incident_id | date | state | city_or_county | address | n_killed | n_injured | incident_url | source_url | incident_url_fields_missing | congressional_district | gun_stolen | gun_type | incident_characteristics | latitude | location_description | longitude | n_guns_involved | notes | participant_age | participant_age_group | participant_gender | participant_name | participant_relationship | participant_status | participant_type | sources | state_house_district | state_senate_district |
|-------------|------|-------|----------------|---------|----------|-----------|--------------|------------|-----------------------------|------------------------|------------|----------|--------------------------|----------|----------------------|-----------|-----------------|-------|-----------------|-----------------------|--------------------|------------------|--------------------------|--------------------|------------------|---------|----------------------|-----------------------|
| 1081561 | 3/29/2018 | Colorado | Pueblo | 617 W Northern Ave | 0 | 0 | http://www.gunviolencearchive.org/incident/1081561 | https://www.chieftain.com/news/crime/pueblo-sheriff-seizes-illegal-guns-drugs-cash-in-bessemer-building/article_436d713a-4be6-565f-a919-747ab83e66df.html | False | 3 | 0::Stolen\|\|1::Unknown\|\|2::Unknown\|\|3::Unknown\|\|4::Unknown\|\|5::Unknown\|\|6::Unknown\|\|7::Unknown\|\|8::Unknown\|\|9::Unknown\|\|10::Unknown\|\|11::Unknown\|\|12::Unknown\|\|13::Unknown\|\|14::Unknown\|\|15::Unknown\|\|16::Unknown\|\|17::Unknown\|\|18::Unknown\|\|19::Unknown\|\|20::Unknown\|\|21::Unknown\|\|22::Unknown\|\|23::Unknown\|\|24::Unknown | 0::Handgun\|\|1::Handgun\|\|2::Unknown\|\|3::Unknown\|\|4::Unknown\|\|5::Unknown\|\|6::Unknown\|\|7::Unknown\|\|8::Unknown\|\|9::Unknown\|\|10::Unknown\|\|11::Unknown\|\|12::Unknown\|\|13::Unknown\|\|14::Unknown\|\|15::Unknown\|\|16::Unknown\|\|17::Unknown\|\|18::Unknown\|\|19::Unknown\|\|20::Unknown\|\|21::Unknown\|\|22::Unknown\|\|23::Unknown\|\|24::Unknown | Non-Shooting Incident\|\|Drug involvement\|\|ATF/LE Confiscation/Raid/Arrest\|\|Possession (gun(s) found during commission of other crimes)\|\|Possession of gun by felon or prohibited person\|\|Stolen/Illegally owned gun{s} recovered during arrest/warrant | 38.2442 | Bessemer | -104.618 | 25 | Guns and drugs recovered from residence. | 0::43 | 0::Adult 18+ | 0::Male | 0::Phillip W. Key |  | 0::Unharmed, Arrested | 0::Subject-Suspect | https://www.chieftain.com/news/crime/pueblo-sheriff-seizes-illegal-guns-drugs-cash-in-bessemer-building/article_436d713a-4be6-565f-a919-747ab83e66df.html | 46 | 3 |
