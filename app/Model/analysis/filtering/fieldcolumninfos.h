#ifndef FIELDCOLUMNINFOS_H
#define FIELDCOLUMNINFOS_H

#include <QObject>
#include "annotation.h"

class FieldColumnInfos : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Annotation* annotation READ annotation WRITE setAnnotation NOTIFY annotationChanged)
    Q_PROPERTY(bool isDisplayed READ isDisplayed WRITE setIsDisplayed NOTIFY isDisplayedChanged)
    Q_PROPERTY(QString sortFilter READ sortFilter WRITE setSortFilter NOTIFY sortFilterChanged)
    Q_PROPERTY(int displayOrder READ displayOrder WRITE setDisplayOrder NOTIFY displayOrderChanged)
    Q_PROPERTY(float width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(SpecialRole role READ role WRITE setRole)

public:
    enum SpecialRole
    {
        NormalAnnotation,
        RowHeader,
        SamplesNames
    };

    explicit FieldColumnInfos(QObject *parent = nullptr);
    explicit FieldColumnInfos(Annotation* annotation, bool isDisplayed, int displayOrder=-1, QString sortFilter="", QObject *parent = nullptr);

    // Getters
    inline Annotation* annotation() { return mAnnotation;}
    inline bool isDisplayed() { return mIsDisplayed; }
    inline QString sortFilter() { return mSortFilter; }
    inline int displayOrder() { return mDisplayOrder; }
    inline float width() { return mWith; }
    inline SpecialRole role() { return mRole;}

    // Setters
    inline void setAnnotation(Annotation* annotation) { mAnnotation = annotation; emit annotationChanged(); }
    inline void setIsDisplayed(bool isDisplayed) { mIsDisplayed = isDisplayed; emit isDisplayedChanged(); }
    inline void setSortFilter(QString sortFilter) { mSortFilter = sortFilter; emit sortFilterChanged(); }
    inline void setDisplayOrder(int displayOrder) { mDisplayOrder = displayOrder; emit displayOrderChanged(); }
    inline void setWidth(float width) { mWith = width; emit widthChanged(); }
    inline void setRole(SpecialRole role) { mRole = role; }

Q_SIGNALS:
    void annotationChanged();
    void isDisplayedChanged();
    void sortFilterChanged();
    void displayOrderChanged();
    void widthChanged();


private:
    Annotation* mAnnotation = nullptr;
    bool mIsDisplayed;
    QString mSortFilter;
    int mDisplayOrder;
    float mWith;
    SpecialRole mRole;
};

#endif // FIELDCOLUMNINFOS_H
