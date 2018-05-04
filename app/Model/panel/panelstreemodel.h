#ifndef PANELSTREEMODEL_H
#define PANELSTREEMODEL_H

#include "Model/framework/treemodel.h"
#include "panel.h"

class PanelsTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingChanged)

public:
    enum Roles
    {
        PanelId = Qt::UserRole + 1,
        VersionId,
        Name,
        Comment,
        Date,
        Shared,
        SearchField
    };

    // Constructor
    explicit PanelsTreeModel(QObject* parent=nullptr);

    // Getters
    inline bool isLoading() { return mIsLoading; }

    // Setters
    inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingChanged(); }

    // Methods
    void refresh(QJsonArray json);
    QHash<int, QByteArray> roleNames() const override;
    QVariant newPanelsTreeItem(QString id, const QString& version, const QString& text);
    void setupModelData(QJsonArray data, TreeItem *parent);
    void setupModelPaneVersionData(Panel* panel, TreeItem *parent);

Q_SIGNALS:
    void isLoadingChanged();

private:
    bool mIsLoading;
};

#endif // PANELSTREEMODEL_H
