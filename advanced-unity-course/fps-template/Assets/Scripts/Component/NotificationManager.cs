using System;
using System.Collections.Generic;
using UnityEngine;

public class NotificationManager : MonoBehaviour
{
    private Dictionary<string, Action> _notificationTable;

    private Action<string> _generalActions;

    public void Awake()
    {
        _notificationTable = new Dictionary<string, Action>();
    }

    public void Listen(string notification, Action a)
    {
        if (_notificationTable.ContainsKey(notification))
        {
            _notificationTable[notification] += a;
        }
        else
        {
            _notificationTable.Add(notification, a);
        }
    }

    public void Ignore(string notification, Action a)
    {
        if (_notificationTable.ContainsKey(notification))
        {
            _notificationTable[notification] -= a;
        }
    }

    public void Call(string notification)
    {
        if (_notificationTable.ContainsKey(notification))
        {
            _notificationTable[notification]();
        }

        if (_generalActions != null)
        {
            _generalActions(notification);
        }
    }

    public void GeneralListen(Action<string> action)
    {
        _generalActions += action;
    }

    public void GeneralIgnore(Action<string> action)
    {
        _generalActions -= action;
    }
}