#ifndef FIELDCOLUMNINFOS_H
#define FIELDCOLUMNINFOS_H

#include <QObject>
#include "annotation.h"

class FieldColumnInfos : public QObject
{
    Q_OBJECT
    // The uid of the field/annotation
    Q_PROPERTY(QString uid READ uid NOTIFY annotationChanged)
    // The associated annotations
    Q_PROPERTY(Annotation* annotation READ annotation WRITE setAnnotation NOTIFY annotationChanged)
    // Current status of the fields in the UI VariantTable (is the column displayed or not)
    Q_PROPERTY(bool isDisplayed READ isDisplayed WRITE setIsDisplayed NOTIFY isDisplayedChanged)
    // Current status of the fields in the UI annotation's treeView that allow to check which columns shall be displayed in the UI VariantTable
    Q_PROPERTY(bool isDisplayedTemp READ isDisplayedTemp WRITE setIsDisplayedTemp NOTIFY isDisplayedTempChanged)
    // Sort order applyed to this column ("": no sort,
    Q_PROPERTY(QString sortFilter READ sortFilter WRITE setSortFilter NOTIFY sortFilterChanged)
    // pixel width of the column in the UI VariantTable
    Q_PROPERTY(float width READ width WRITE setWidth NOTIFY widthChanged)

public:
    // Constructors
    FieldColumnInfos(QObject *parent = nullptr);
    FieldColumnInfos(Annotation* annotation, bool isDisplayed, QString sortFilter="", QObject *parent = nullptr);

    // Getters
    inline QString uid() { return !mUIUid.isEmpty() ? mUIUid : mAnnotation != nullptr ? mAnnotation->uid() : ""; }
    inline Annotation* annotation() { return mAnnotation;}
    inline bool isDisplayed() { return mIsDisplayed; }
    inline bool isDisplayedTemp() { return mIsDisplayedTemp; }
    inline QString sortFilter() { return mSortFilter; }
    inline float width() { return mWith; }

    // Setters
    inline void setAnnotation(Annotation* annotation) { mAnnotation = annotation; emit annotationChanged(); }
    inline void setIsDisplayed(bool isDisplayed) { mIsDisplayed = isDisplayed; mIsDisplayedTemp = isDisplayed; emit isDisplayedChanged(); }
    inline void setIsDisplayedTemp(bool isDisplayedTemp) { mIsDisplayedTemp = isDisplayedTemp; emit isDisplayedTempChanged(); }
    inline void setSortFilter(const QString& sortFilter) { mSortFilter = sortFilter; emit sortFilterChanged(); }
    inline void setWidth(float width) { mWith = width; emit widthChanged(); }
    inline void setUIUid(const QString& uid) { mUIUid = uid; }

    inline bool isAnnotation() { return mUIUid.isEmpty() && mAnnotation != nullptr; }

Q_SIGNALS:
    void annotationChanged();
    void isDisplayedChanged();
    void isDisplayedTempChanged();
    void sortFilterChanged();
    void widthChanged();


private:
    QString mUIUid;
    Annotation* mAnnotation = nullptr;
    bool mIsDisplayed = false;
    bool mIsDisplayedTemp = false;
    QString mSortFilter;
    float mWith = 0;
};

#endif // FIELDCOLUMNINFOS_H
