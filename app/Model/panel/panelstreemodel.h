#ifndef PANELSTREEMODEL_H
#define PANELSTREEMODEL_H

#include "Model/framework/treemodel.h"
#include "panel.h"

class PanelsTreeModel : public TreeModel
{
    Q_OBJECT
    Q_PROPERTY(bool isLoading READ isLoading WRITE setIsLoading NOTIFY isLoadingChanged)

public:
    enum JsonModelRoles
    {
        Name = Qt::UserRole + 1,
        Comment,
        Date,
        Shared
    };

    // Constructor
    explicit PanelsTreeModel();

    // Getters
    inline bool isLoading() { return mIsLoading; }

    // Setters
    inline void setIsLoading(bool isLoading) { mIsLoading = isLoading; emit isLoadingChanged(); }

    // Methods
    QHash<int, QByteArray> roleNames() const override;
    void refresh(QJsonObject json);
    QVariant newPanelsTreeItem(int id, const QString& version, const QString& text);
    void setupModelData(QJsonArray data, TreeItem *parent);
    void setupModelPaneVersionData(Panel* panel, TreeItem *parent);

Q_SIGNALS:
    void isLoadingChanged();


private:
    bool mIsLoading;
};

#endif // PANELSTREEMODEL_H
