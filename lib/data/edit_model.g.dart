// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEditCollection on Isar {
  IsarCollection<Edit> get edits => this.collection();
}

const EditSchema = CollectionSchema(
  name: r'Edit',
  id: -5352439786397049675,
  properties: {
    r'content': PropertySchema(
      id: 0,
      name: r'content',
      type: IsarType.string,
    ),
    r'contentWords': PropertySchema(
      id: 1,
      name: r'contentWords',
      type: IsarType.stringList,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _editEstimateSize,
  serialize: _editSerialize,
  deserialize: _editDeserialize,
  deserializeProp: _editDeserializeProp,
  idName: r'id',
  indexes: {
    r'contentWords': IndexSchema(
      id: -9211142823111558917,
      name: r'contentWords',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'contentWords',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'note': LinkSchema(
      id: -8490253850220663577,
      name: r'note',
      target: r'Note',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _editGetId,
  getLinks: _editGetLinks,
  attach: _editAttach,
  version: '3.1.0+1',
);

int _editEstimateSize(
  Edit object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.contentWords.length * 3;
  {
    for (var i = 0; i < object.contentWords.length; i++) {
      final value = object.contentWords[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _editSerialize(
  Edit object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.content);
  writer.writeStringList(offsets[1], object.contentWords);
  writer.writeDateTime(offsets[2], object.createdAt);
}

Edit _editDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Edit();
  object.content = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.id = id;
  return object;
}

P _editDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _editGetId(Edit object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _editGetLinks(Edit object) {
  return [object.note];
}

void _editAttach(IsarCollection<dynamic> col, Id id, Edit object) {
  object.id = id;
  object.note.attach(col, col.isar.collection<Note>(), r'note', id);
}

extension EditQueryWhereSort on QueryBuilder<Edit, Edit, QWhere> {
  QueryBuilder<Edit, Edit, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Edit, Edit, QAfterWhere> anyContentWordsElement() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'contentWords'),
      );
    });
  }
}

extension EditQueryWhere on QueryBuilder<Edit, Edit, QWhereClause> {
  QueryBuilder<Edit, Edit, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Edit, Edit, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Edit, Edit, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Edit, Edit, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterWhereClause> contentWordsElementEqualTo(
      String contentWordsElement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'contentWords',
        value: [contentWordsElement],
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterWhereClause> contentWordsElementNotEqualTo(
      String contentWordsElement) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'contentWords',
              lower: [],
              upper: [contentWordsElement],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'contentWords',
              lower: [contentWordsElement],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'contentWords',
              lower: [contentWordsElement],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'contentWords',
              lower: [],
              upper: [contentWordsElement],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Edit, Edit, QAfterWhereClause> contentWordsElementGreaterThan(
    String contentWordsElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'contentWords',
        lower: [contentWordsElement],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterWhereClause> contentWordsElementLessThan(
    String contentWordsElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'contentWords',
        lower: [],
        upper: [contentWordsElement],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterWhereClause> contentWordsElementBetween(
    String lowerContentWordsElement,
    String upperContentWordsElement, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'contentWords',
        lower: [lowerContentWordsElement],
        includeLower: includeLower,
        upper: [upperContentWordsElement],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterWhereClause> contentWordsElementStartsWith(
      String ContentWordsElementPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'contentWords',
        lower: [ContentWordsElementPrefix],
        upper: ['$ContentWordsElementPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterWhereClause> contentWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'contentWords',
        value: [''],
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterWhereClause> contentWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'contentWords',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'contentWords',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'contentWords',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'contentWords',
              upper: [''],
            ));
      }
    });
  }
}

extension EditQueryFilter on QueryBuilder<Edit, Edit, QFilterCondition> {
  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition>
      contentWordsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentWords',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contentWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contentWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contentWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contentWords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentWords',
        value: '',
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition>
      contentWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contentWords',
        value: '',
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentWords',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentWords',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentWords',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentWords',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentWords',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> contentWordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentWords',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EditQueryObject on QueryBuilder<Edit, Edit, QFilterCondition> {}

extension EditQueryLinks on QueryBuilder<Edit, Edit, QFilterCondition> {
  QueryBuilder<Edit, Edit, QAfterFilterCondition> note(FilterQuery<Note> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'note');
    });
  }

  QueryBuilder<Edit, Edit, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'note', 0, true, 0, true);
    });
  }
}

extension EditQuerySortBy on QueryBuilder<Edit, Edit, QSortBy> {
  QueryBuilder<Edit, Edit, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<Edit, Edit, QAfterSortBy> sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<Edit, Edit, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Edit, Edit, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }
}

extension EditQuerySortThenBy on QueryBuilder<Edit, Edit, QSortThenBy> {
  QueryBuilder<Edit, Edit, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<Edit, Edit, QAfterSortBy> thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<Edit, Edit, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Edit, Edit, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Edit, Edit, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Edit, Edit, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension EditQueryWhereDistinct on QueryBuilder<Edit, Edit, QDistinct> {
  QueryBuilder<Edit, Edit, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Edit, Edit, QDistinct> distinctByContentWords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentWords');
    });
  }

  QueryBuilder<Edit, Edit, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }
}

extension EditQueryProperty on QueryBuilder<Edit, Edit, QQueryProperty> {
  QueryBuilder<Edit, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Edit, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<Edit, List<String>, QQueryOperations> contentWordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentWords');
    });
  }

  QueryBuilder<Edit, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }
}
